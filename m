Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab3E1Ref (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:34:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46865 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934735Ab3E1Ree (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:34:34 -0400
Date: Tue, 28 May 2013 20:33:45 +0300
From: Felipe Balbi <balbi@ti.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Felipe Balbi'" <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        "'Greg KH'" <gregkh@linuxfoundation.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Praveen Paneri'" <p.paneri@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] usb: phy: samsung: Add support for EXYNOS4210
Message-ID: <20130528173345.GC15794@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <000301ce5b82$4fa829e0$eef87da0$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Content-Disposition: inline
In-Reply-To: <000301ce5b82$4fa829e0$eef87da0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2013 at 06:04:07PM +0900, Jingoo Han wrote:
> @@ -165,6 +174,18 @@ static void samsung_usb2phy_enable(struct samsung_us=
bphy *sphy)
>  	u32 phyclk;
>  	u32 rstcon;
> =20
> +	switch (sphy->drv_data->cpu_type) {
> +	case TYPE_EXYNOS4210:
> +		atomic_inc(&sphy->phy_usage);

please switch over to the generic reference counting which I have
pending in my testing branch. It'll be available for v3.11 merge window.

--=20
balbi

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRpOp5AAoJEIaOsuA1yqRE8VcP/Aha+/Nm90RGNGMB5v9nJiwI
LtpFIOUBlIfVJIEk6BkHY6NWypJu359ATLRytEvxW4vFf3cuNikm7cGOnAfmF5Bp
K7CQ8HTik04mB3R7IW7V4vIL7xAqUDYuXH4P/9QL0mbsSxAYUSATjXMZP4m8/a8Z
K/XHpqyshbOzmqdnNuB4flJ1CEZFsLMgisE4z20f7L/E1WANLjJrCEwQ+JTrdJu5
KqIJTbChO+bGKyDdB63NWjn0Atrta2iXN+xbTbNm02Q+T4kyiXJXI8FRqhiDa8rI
9zN6Zbeax24Rtz9e9CzCfTDPBBFK5uIPg/bSCJor0lEMTbKT4MHWq9uqLmpGKYsD
qzdKE0eVzyhmEVwdlMGw16C2cZ0qsEhZbFV0oCNPUYreUUt0UtwyaXwzqVdFzZYc
fXA+Xz/94LYedrscWuhWYwbfb/ZPTTW15Ti2+WCLLfdVBMDEOuwAYzBSKGbR15/A
wyZm2xdSJEntuBZvk0YapxKWjCSpNH6n1fSNtSTqY2N4ou2exfQanTT5kyYzBBz/
fLgYcSPZHUYMn1scYFwDM5O2mxJ6YsJKxrExJlHzACPaqBEPnEbjiBH3Zb+BJl+N
++i6Ogntjr3dgMm7w4LHbQZLYwCJBLBkRvKR0s4sRLQ/ZuDQcC6vjRpd92QZsgbM
v4IfBw/8TAImYdhzDdSd
=JTfI
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
