Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176Ab3BTA3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:29:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36971 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618Ab3BTA3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:29:07 -0500
Date: Wed, 20 Feb 2013 11:29:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>, John Crispin <blogic@openwrt.org>
Subject: Re: linux-next: build failure after merge of the mips tree
Message-Id: <20130220112903.69946023ad0d9739bc063dc1@canb.auug.org.au>
In-Reply-To: <20130218104340.eb5e20da05dffe89ac4da693@canb.auug.org.au>
References: <20130218104340.eb5e20da05dffe89ac4da693@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Feb_2013_11_29_03_+1100_eHDrrPqiAT1inR=J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Feb_2013_11_29_03_+1100_eHDrrPqiAT1inR=J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

On Mon, 18 Feb 2013 10:43:40 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the mips tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/ssb/driver_gpio.c: In function 'ssb_gpio_chipco_to_irq':
> drivers/ssb/driver_gpio.c:82:3: error: implicit declaration of function '=
ssb_mips_irq' [-Werror=3Dimplicit-function-declaration]
>=20
> Caused by commit d630dd4ef20f ("ssb: add gpio_to_irq again").
>=20
> I have used the mips tree from next-20130215 for today.

I am still getting this build problem.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__20_Feb_2013_11_29_03_+1100_eHDrrPqiAT1inR=J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJBjPAAoJEECxmPOUX5FE5GIP/jABwPgdGmwRCdzBCQXW37N/
IrvgSJY3AkKj19y6dvbnD7R3J0r2vuSCg6YzK+59s3IuH87xZrbhtYUK8hZ0+vVr
cEFULEwq3lAWmfVxGaYJpRHXtRvgPMWkK3JL+NM4FXvl8kdctmuCE0X3r4g9lPdG
5r8wYT5K9HMBaOjD5RBQO9463MrtUCoyBJgez7GxEwg88Dxw9yqIAwC+fQeZ9w6S
QfcSh/y02Gl26VFJmRy8GoyG4wE1EZVqGGTh4wLg8ujlrh24n3eq151QPK26aQ/0
ebBSY1zt/hqzKt18YTntEcul4UyBAG7LVrrMGxVXQIqySYSFPvn9hBIjPvikNA97
CaaCuMjkCg8gHVHdeEtGf16OZ0k/n2T5UrDQnUsiejJmNUQ67ILOzez+H7ZGIjU1
ivZ4C6pD2+Q91s1NFLMqnBDfkp7E/CH5PI7KpYeS/4k5RKLzHhs6Do1WkV5wHee5
YV/K8WVm4tdWfvYRkq03ynjGd6hcOEhC0hHUknhbQps51Sml+ePqAiH5XI4Oxivi
5M4lTV+vijDuohd0XaWFUYeEvpxlc2/3Oxq+x8h1fK/bUBd0nB93j5sqZ57cdcEt
43cCUrJ6AmlXEIXxFTEO/SmjTOGx2j8PmvIBNYqBK0NcxyZ1ddF7JGl/HiE/dsSY
fyEGjT0vNrXHpMfBWYgp
=4hUr
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Feb_2013_11_29_03_+1100_eHDrrPqiAT1inR=J--
