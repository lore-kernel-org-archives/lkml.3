Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaDYQVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:21:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41335 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaDYQSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:18:25 -0400
Date: Fri, 25 Apr 2014 11:17:52 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v5 1/5] doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue
Message-ID: <20140425161752.GT29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395223803-4714-1-git-send-email-george.cherian@ti.com>
 <1395223803-4714-2-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VvnGyWaJ9JuxX38U"
Content-Disposition: inline
In-Reply-To: <1395223803-4714-2-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VvnGyWaJ9JuxX38U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 03:39:59PM +0530, George Cherian wrote:
> Add the compatible "ti,am437x-dwc3" for dwc3 glue driver.
>=20
> Signed-off-by: George Cherian <george.cherian@ti.com>
> Acked-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  Documentation/devicetree/bindings/usb/omap-usb.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documen=
tation/devicetree/bindings/usb/omap-usb.txt
> index 38b2fae..38d9bb8 100644
> --- a/Documentation/devicetree/bindings/usb/omap-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
> @@ -44,7 +44,9 @@ Board specific device node entry
>  };
> =20
>  OMAP DWC3 GLUE
> - - compatible : Should be "ti,dwc3"
> + - compatible : Should be
> +	* "ti,dwc3" for OMAP5 and DRA7
> +	* "ti,am437x-dwc3" for AM437x
>   - ti,hwmods : Should be "usb_otg_ss"
>   - reg : Address and length of the register set for the device.
>   - interrupts : The irq number of this device that is used to interrupt =
the
> --=20
> 1.8.3.1
>=20

--=20
balbi

--VvnGyWaJ9JuxX38U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWoqwAAoJEIaOsuA1yqREw0sP/RIe0e385OvMangWEneBGIQn
cIVW46l/8ofsG1h/AUBBSjMgBAyiGXcuAq4xsM+PH1rhl9/ypeQ81JTC9OcWgtfX
Vuz1qABiWwAGDJlrn6LcBgXWrTXzl7l6kOs3eHUFTGPDUlDSB6XAb/3VcpRUT2ap
WclwTVjR9/SqIqmpJtOkQX2VfFpaoj5qHlNmYfK8etCq08uVeLdvk2FG6AeU6mpd
VEvupHuxDww244HflPUoFcut1dudXPwegdHVqPqXZeALT0iUR5gqnDe89HmIPug2
WxqWUVLQ/lVMkXnHfWeSrV/Mrwrt9yyAzC3BMplMfl8wAk8jnj9tBnhC4T/tGjZ4
z9jT5qwy0VpH8vGv3KrSO2DWyb51Wr6t7FlKs7nGWcIyFGYNfX+m7ZoZul1atP6E
0jDRpAwErjKB6+niDgvyao/KGGq3n96FUOA6ImmqKKHIbpuU6gjJ8cOcEqiEsciF
2jryzZHHPF+DOB98Tte5hOI42v5CewAANxiOxk9kBUaQKgv7nOrtEREJJYCou7I+
l6zqz5TOw8skbIIlUtxr7rzZPgcLOXcmXpA5JEB+gEl4cPNaEmBu76BBLfjKGPKE
3rQeBfoamQLcvtDTSIj2UByF48C5QjGtg/FfQKINFU/sPDwsG9FUuwLqWg3Fh1Qk
AUFjsebfIxGBmWJ5ANkV
=NdTo
-----END PGP SIGNATURE-----

--VvnGyWaJ9JuxX38U--
