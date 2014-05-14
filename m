Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaENMfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:35:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46081 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751070AbaENMfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:35:04 -0400
Date: Wed, 14 May 2014 14:30:55 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        hdegoede@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH RESEND v4 4/8] phy: usb: sunxi: Introduce Allwinner A31
 USB PHY support
Message-ID: <20140514123055.GJ29258@lukather>
References: <1399995862-17788-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399995862-17788-5-git-send-email-maxime.ripard@free-electrons.com>
 <53732BC9.3020507@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7Ke/meiCZutM6I/"
Content-Disposition: inline
In-Reply-To: <53732BC9.3020507@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7Ke/meiCZutM6I/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 14, 2014 at 02:09:37PM +0530, Kishon Vijay Abraham I wrote:
> > @@ -305,6 +315,7 @@ static int sun4i_usb_phy_probe(struct platform_devi=
ce *pdev)
> >  static const struct of_device_id sun4i_usb_phy_of_match[] =3D {
> >  	{ .compatible =3D "allwinner,sun4i-a10-usb-phy" },
> >  	{ .compatible =3D "allwinner,sun5i-a13-usb-phy" },
> > +	{ .compatible =3D "allwinner,sun6i-a31-usb-phy" },
>=20
> Do you have Documentation for this comptible binding? Would be good to me=
ntion
> that in the commit log.

Ah right. I forgot.

I'm sending you a followup patch.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--C7Ke/meiCZutM6I/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTc2H/AAoJEBx+YmzsjxAgrBcP/RK3ockFWJFyzRyGpk3nsjR4
QwYlSRzebcLqbB23el7+uIwzLsNpNaMRGeanL2ug677wwk2XLoIpTYTELnODzMxF
zRd6ZFovL0oJufaSZMS+0LSfCBLKUysOag6e4IKCGJaATip2dkkiPZ2digWGhc1n
521QwcofZMNobQUwH11VFIV8S4ablWpQUmL6msWBUFkfcfBohV2ioUTpVk7KEO+z
OpXbdTYNQ4h6GyUxrJGi7+6wX3OsnO6zwV6y9HJHZ9auaVI4/XzT3wd2/tQmw4v2
a/l9uRfwlfA8FJWG6NXn/qp/5FYnTV3JGh8mhVRydQKyxQC92Id0U5f99lY13Jxg
bYt+QnH//DIKlMKS+QWVRtQECdgFvl6ChUKdsi/qzajugqswa9gUesgjEqBDyQ2v
FjI6NsC9J+F/dwszBeJJTaRxLbp+LQyRNKSXQkqaTEDBchn3iYO6KZfbMCXLsyqZ
0J06sYpAZ9NoSr8bhXof/TuLgLJ/eZMAalWrBDh1vwGbb+Y2tdSwShsDS/fvISrD
B6bbnMAzE+ueJBHDuV5QF9NloGYnM/VZpzwlzyUdCqM6xlaT4vSK0YHd37im18in
CFYVIbmtbVeIOPQoYSIIXANRERGAYHjA7cQPvhyBuZyYfGLnjFtg8lmjFbXtL9Au
gi9mJobrLEFlPg7Vhx/t
=pg+/
-----END PGP SIGNATURE-----

--C7Ke/meiCZutM6I/--
