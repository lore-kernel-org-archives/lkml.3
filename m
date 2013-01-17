Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3AQLpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:45:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48077 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3AQLpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:45:41 -0500
Date: Thu, 17 Jan 2013 13:45:22 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 15/22] mfd: omap-usb-host: Manage HSIC clocks for HSIC
 mode
Message-ID: <20130117114522.GF18978@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
 <1358422231-24736-16-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sDKAb4OeUBrWWL6P"
Content-Disposition: inline
In-Reply-To: <1358422231-24736-16-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sDKAb4OeUBrWWL6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 17, 2013 at 01:30:24PM +0200, Roger Quadros wrote:
> @@ -598,6 +639,24 @@ static int usbhs_omap_probe(struct platform_device *=
pdev)
>  				clkname, PTR_ERR(pclk));
>  		else
>  			omap->utmi_clk[i] =3D pclk;
> +
> +		snprintf(clkname, sizeof(clkname),
> +				"usb_host_hs_hsic480m_p%d_clk", i + 1);

do we really need to know the exact clock node name ?

--=20
balbi

--sDKAb4OeUBrWWL6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9+RSAAoJEIaOsuA1yqREFdQP/i4/h4sPTWAp/1FpMay0+OBV
bynihYocfqKf++YCehpqxQ2MwdZhsOI+66VhG0U1tfCgxKtvldhYcnsx24Z6OT/J
RBu9zTh9kKj/COV1Ag96RXITy5rJfkA3apw+rQ4QnKnAXlSWRDsCVYX0N//DDq0f
weoN9jLt1xyIPL0kKlicV4m4DSwb7JRUsCxSilHbxITF03wR0HhWiS0/C4L0S2je
vg/ryQzmvETctajJeuS0OFWkkkNGsNOCq5mFcua3JfHmj45HxTWc2EQ1/c0b9V4X
JvjXlOx4Dlc6aGm9/Jw7wscqwio1I7iugfqPOGvtpaXwLXa5kbZ35EDerQjjFQ0J
QBevEXcwGVlbL2Oejy658B+VyONAC+wfuioYA12Sb1t+3Ojez4WBqk3kYNSfGdIh
G4qeD7utuYOTNZ0mSFsd9DNFldTz5kBboc9rUaa5LujbfmU68hvirSLOrGlf5McO
1ndEpxPutqz72U3RuabatEN5PyxLhPTTBMMG1L2GN3F7B/FDUYSkcvCram+J1tup
TcKIfzBtMynHxORYTPszWg7g0XMrS9T4CaYq1yYD0Fva3wXVdwPKprpmaymVnySU
+0pHarhCV5OUTSo0Oszen7vXK+5iTtT2MfgGM42HksN9g0DyYUBVLc44x4kz/we8
S5OgnJuGrzBQYc9LS+rX
=6Ufz
-----END PGP SIGNATURE-----

--sDKAb4OeUBrWWL6P--
