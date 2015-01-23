Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbbAWRrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:47:21 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59017 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbbAWRrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:47:19 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: N900 v3.19-rc5 errors
Date: Fri, 23 Jan 2015 18:47:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: "linux-omap" <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
References: <201501231415.56922@pali> <20150123172012.GA12344@roeck-us.net>
In-Reply-To: <20150123172012.GA12344@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1940322.5JGjEy15gW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501231847.15243@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1940322.5JGjEy15gW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 23 January 2015 18:20:12 Guenter Roeck wrote:
> On Fri, Jan 23, 2015 at 02:15:56PM +0100, Pali Roh=C3=A1r wrote:
> > Hello,
>=20
> > I'm getting these two errors when booting DT linux v3.19-rc5=20
in n900 qemu:
> Hello Pali,
>=20
> can you send me the kernel confguration and qemu command line
> you are using ?
>=20
> Thanks,
> Guenter

Hello,

instructions how to use qemu for n900 I wrote on uboot ml:
http://lists.denx.de/pipermail/u-boot/2015-January/200171.html

Just replace u-boot.bin file with bootable kernel image zImage.=20
In above instructions is u-boot.bin booted as regular kernel=20
image by Nokia bootloader. If you do not have qflasher (for=20
generating qemu MTD nand image) + Nokia bootloaders and you are=20
OK with Nokia license I can provide you needed binaries.

Kernel config which I used you can find on:
https://gitorious.org/linux-n900/linux-n900/source/v3.19-rc5-n900:arch/arm/=
configs/rx51_defconfig

There is also v3.19-rc5-n900 branch which contains some patches:
https://gitorious.org/linux-n900/linux-n900

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1940322.5JGjEy15gW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEABECAAYFAlTCiSMACgkQi/DJPQPkQ1Ja2ACfdCBPE89AXMcJ7bF/IlBLa3dc
TDUAljuLIM9k8cybI+rXr68iY2Tl0As=
=U4wD
-----END PGP SIGNATURE-----

--nextPart1940322.5JGjEy15gW--
