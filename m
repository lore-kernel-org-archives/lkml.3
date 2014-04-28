Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbaD1XfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:35:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54230 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753252AbaD1XfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:35:07 -0400
Date: Mon, 28 Apr 2014 16:31:03 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chen-Yu Tsai <wens@csie.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH 4/7] mfd: sun6i-prcm: document DT bindings
Message-ID: <20140428233103.GS3134@lukather>
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
 <1398697130-8338-5-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R+WA+n3pAWWgNWUs"
Content-Disposition: inline
In-Reply-To: <1398697130-8338-5-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R+WA+n3pAWWgNWUs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 04:58:47PM +0200, Boris BREZILLON wrote:
> Document DT bindings of the PRCM (Power/Reset/Clock Management) unit.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  .../devicetree/bindings/mfd/sun6i-prcm.txt         | 71 ++++++++++++++++=
++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
>=20
> diff --git a/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt b/Docum=
entation/devicetree/bindings/mfd/sun6i-prcm.txt
> new file mode 100644
> index 0000000..de92429
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
> @@ -0,0 +1,71 @@
> +* Allwinner PRCM (Power/Reset/Clock Management) Multi-Functional Device
> +
> +PRCM is an MFD device exposing several Power Management related devices
> +(like clks and reset controllers).
> +
> +Required properties:
> + - compatible: "allwinner,sun6i-a31-prcm"
> + - reg: The PRCM registers range
> +
> +The prcm node may contain several subdevices definitions:
> + - see Documentation/devicetree/clk/sunxi.txt for clock devices
> + - see Documentation/devicetree/reset/allwinner,sunxi-clock-reset.txt fo=
r reset
> +   controller devices
> +
> +
> +Example:
> +
> +	prcm: prcm@01f01400 {
> +		compatible =3D "allwinner,sun6i-a31-prcm";
> +		reg =3D <0x01f01400>;

You're missing the size of the address range here.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--R+WA+n3pAWWgNWUs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTXuS2AAoJEBx+YmzsjxAgCegQAIM+fxtU/Gv2sdIPlbtRaKWI
ZwloPCtafLM5DJhtPDCzzmd3EFE6lFwousQMSZdsaY8+W1uxRe6KNzoT67Tkr1ts
vpsIYKFrdFzEuvsGzccEF+eOdU4u0TaTkPnYZbLtGAj44lcubv28H3NQuEhhEHG1
FqHJouyBZ4hTSsPV7DipZZLGTuR40hQyJK9w5GTKH81dhk2eG+VaCM3t+YJOk6fn
VPVtDKz47xuK9x4IOZ6OqKibepsbDdZ7wAdWfowMfG17K3lLuF/h4jeLkDsy+sQy
i9jCifwNwGptjUE4nntg1jYXdj3q1L/nDjIVoVpRy/iW8x4bYZicwx7Ca9LbDnUw
YFEBSMEXqQNeZayYZzl3XArQ0ijaHBmHFItlMbRvwP9gBZG4XXBThqWKqam3zjH8
qSN3Pq3R95WDM5juq/7uA8cdV6oTRmXtD25vJ6EFLTg+8d5WHo0t9FAaI252XWev
YhwIMAYJ3hxFeicHza3gMjoCRc8XsC1HwCAKkYxNFcGs7HfvN4b1TOgSI0JU8DXi
xaqV0iow2HdfLWMfUecVlVgn1kHOs8mC4s3RItHul4uCIf/Q1c51Bcm8BhlUeem6
I0dOVdrKb9MDnTGCy97prmbewGApKBORmRR7sfp10QvunG73MjOFuqlLA3bBywp2
qsqjhuU1QOQ222ulnee1
=IaLo
-----END PGP SIGNATURE-----

--R+WA+n3pAWWgNWUs--
