Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbaE2JhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:37:15 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39253 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbaE2JhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:37:12 -0400
Message-ID: <5386FFC0.5010200@monstr.eu>
Date: Thu, 29 May 2014 11:37:04 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Harini Katakam <harinik@xilinx.com>, wim@iguana.be,
        grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net
CC: michals@xilinx.com, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] devicetree: Add Cadence WDT devicetree bindings
 documentation
References: <1401185895-3677-1-git-send-email-harinik@xilinx.com> <1401185895-3677-2-git-send-email-harinik@xilinx.com>
In-Reply-To: <1401185895-3677-2-git-send-email-harinik@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="PnX8Orn5469vrsjviSUghxMTc5eAUr0GK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PnX8Orn5469vrsjviSUghxMTc5eAUr0GK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/27/2014 12:18 PM, Harini Katakam wrote:
> Add cadence-wdt bindings documentation.
>=20
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> ---
>=20
> v2:
> No changes
>=20
> ---
>  .../devicetree/bindings/watchdog/cadence-wdt.txt   |   26 ++++++++++++=
++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/cadence-=
wdt.txt
>=20
> diff --git a/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt=
 b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> new file mode 100644
> index 0000000..1f7a732
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
> @@ -0,0 +1,26 @@
> +Zynq Watchdog Device Tree Bindings
> +-------------------------------------------
> +
> +Required properties:
> +- compatible		: Should be "xlnx,zynq-wdt-r1p2" or "cdns,wdt-r1p2".
> +- clocks		: Clock phandles (see clock bindings for details).
> +- reg			: Physical base address and size of WDT registers map.
> +- interrupts		: Property with a value describing the interrupt
> +			  number.
> +- interrupt-parent	: Must be core interrupt controller.
> +
> +Optional properties
> +- reset			: Reset interrupt.
> +- timeout-sec		: Watchdog timeout value (in seconds).
> +
> +Example:
> +
> +		wdt@f8005000 {

please use watchdog@ here
which is listed in ePAPR

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--PnX8Orn5469vrsjviSUghxMTc5eAUr0GK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOG/8EACgkQykllyylKDCExnACgiVjdAdys9+fbE9SQUhslfe76
0MMAnR/tUN9Ut18sdiwnTGAQthXSAOLG
=h6mK
-----END PGP SIGNATURE-----

--PnX8Orn5469vrsjviSUghxMTc5eAUr0GK--
