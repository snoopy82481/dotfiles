function gsa_perdiem --description "Download GSA Per Diem CONUS zipcodes+lodging for FY; write FY-stamped and CURRENT CSVs into ~/Documents/Development"
    if test (count $argv) -ne 1
        echo "Usage: gsa_perdiem_refresh_fy FY"
        echo "Example: gsa_perdiem_refresh_fy 2026"
        return 1
    end

    set -l API_KEY "3Dq5jjwGfpcuUpoNWofiyxfMVmeSbcG5qTdyZCIg"
    set -l FY $argv[1]
    set -l outdir "$HOME/Documents/Development"

    set -l zip_url "https://api.gsa.gov/travel/perdiem/v2/rates/conus/zipcodes/$FY?api_key=$API_KEY"
    set -l lodg_url "https://api.gsa.gov/travel/perdiem/v2/rates/conus/lodging/$FY?api_key=$API_KEY"

    # FY-stamped
    set -l zip_csv_fy "$outdir/gsa_zipcodes_conus_$FY.csv"
    set -l lodg_csv_fy "$outdir/gsa_lodging_conus_$FY.csv"

    # Stable filenames Excel will always import
    set -l zip_csv_cur "$outdir/gsa_zipcodes_conus_CURRENT.csv"
    set -l lodg_csv_cur "$outdir/gsa_lodging_conus_CURRENT.csv"

    echo "Downloading ZIP→DID dataset for FY $FY..."
    curl -fsSL --retry 5 --retry-delay 2 --retry-all-errors "$zip_url" \
    | jq -r '
        (["Zip","DID","ST"]),
        (.[] | [(.Zip // ""), (.DID // ""), (.ST // "")]) | @csv
      ' > "$zip_csv_fy"
    or begin
        echo "ERROR: Failed zipcodes download/convert."
        rm -f "$zip_csv_fy"
        return 2
    end

    echo "Downloading Lodging dataset for FY $FY..."
    curl -fsSL --retry 5 --retry-delay 2 --retry-all-errors "$lodg_url" \
    | jq -r '
        (["State","DID","City","County","Meals","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]),
        (.[] | [
            (.State // ""),
            (.DID // ""),
            (.City // ""),
            (.County // ""),
            (.Meals // ""),
            (.Jan // ""), (.Feb // ""), (.Mar // ""), (.Apr // ""), (.May // ""), (.Jun // ""),
            (.Jul // ""), (.Aug // ""), (.Sep // ""), (.Oct // ""), (.Nov // ""), (.Dec // "")
        ]) | @csv
      ' > "$lodg_csv_fy"
    or begin
        echo "ERROR: Failed lodging download/convert."
        rm -f "$lodg_csv_fy"
        return 3
    end

    # Copy to stable CURRENT filenames (so Excel doesn't need to change import paths)
    cp -f "$zip_csv_fy" "$zip_csv_cur"
    cp -f "$lodg_csv_fy" "$lodg_csv_cur"

    echo ""
    echo "Done."
    echo "FY ZIP CSV      : $zip_csv_fy"
    echo "FY Lodging CSV   : $lodg_csv_fy"
    echo "CURRENT ZIP CSV  : $zip_csv_cur"
    echo "CURRENT Lodg CSV : $lodg_csv_cur"
end
