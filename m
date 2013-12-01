Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3LAUgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 15:36:45 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:62183 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3LAUgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 15:36:44 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
        =?utf-8?b?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Subject: Re: Compile failure on linux-n900 branch -- MEDIA_CAMERA_SUPPORT needed for n900 compilation
Date: Sun, 1 Dec 2013 21:36:39 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: sre@ring0.de, sre@debian.org, kernel list <linux-kernel@vger.kernel.org>
References: <20131127125149.GA9389@amd.pavel.ucw.cz> <20131201200112.GE9743@amd.pavel.ucw.cz> <20131201202500.GA24067@amd.pavel.ucw.cz>
In-Reply-To: <20131201202500.GA24067@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1958038.qMm5Q8UBqo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312012136.39919@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1958038.qMm5Q8UBqo
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 01 December 2013 21:25:00 Pavel Machek wrote:
> Hi!
>=20
> Interesting; with Sebastian DT config
> (http://elektranox.org/n900-kernel-config.txt), I get the same
>=20
>=20
>=20
> [   17.967651] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.968109] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.968566] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.969055] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.969512] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.969970] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.970428] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.970886] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.971313] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.967651] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.968109] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.968566] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.969055] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.969512] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.969970] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.970428] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.970886] omap_i2c 48070000.i2c: Too much work in one IRQ
> [   17.971313] omap_i2c 48070000.i2c: Too much work in one IRQ
>=20
> ...infinite loop during bootup. So, Sebastian, it looks
> problem is in linux-n900, too. Will switch to defconfig, that
> worked...
>=20
> 									Pavel

Today freemangordon wrote (on IRC), that i2c is broken in 3.13.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1958038.qMm5Q8UBqo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKbndcACgkQi/DJPQPkQ1Im8gCeMeSS2w5OeJM5WxlQHrLpsyTB
QWIAoJMx6s2FNvqP1OtDq6na4MnNc2vD
=hph/
-----END PGP SIGNATURE-----

--nextPart1958038.qMm5Q8UBqo--
