Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbaJWNBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:01:10 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41305 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaJWNBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:01:07 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 3.18.rc1: compile failure in tsc2005.c
Date: Thu, 23 Oct 2014 15:01:04 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com,
        sre@kernel.org, B38611@freescale.com, aaro.koskinen@iki.fi,
        jg1.han@samsung.com, linux-input@vger.kernel.org
References: <20141023125325.GB30572@amd>
In-Reply-To: <20141023125325.GB30572@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5775186.5qjUkLqLxT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410231501.04540@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5775186.5qjUkLqLxT
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 23 October 2014 14:53:25 Pavel Machek wrote:
> Hi!
>=20
> I get this. Before I start patching it, perhaps someone has
> fixed it already?
>=20
> 								Pavel
>=20
>   CC      drivers/input/touchscreen/tsc2005.o
> drivers/input/touchscreen/tsc2005.c: In function
> 'tsc2005_disable_store':
> drivers/input/touchscreen/tsc2005.c:406:2: error: implicit
> declaration of function 'strict_strtoul'
> [-Werror=3Dimplicit-function-declaration] cc1: some warnings
> being treated as errors
> scripts/Makefile.build:257: recipe for target
> 'drivers/input/touchscreen/tsc2005.o' failed
> make[3]: *** [drivers/input/touchscreen/tsc2005.o] Error 1
> scripts/Makefile.build:402: recipe for target
> 'drivers/input/touchscreen' failed
> make[2]: *** [drivers/input/touchscreen] Error 2
> scripts/Makefile.build:402: recipe for target 'drivers/input'
> failed make[1]: *** [drivers/input] Error 2
> make[1]: *** Waiting for unfinished jobs....
>   CC      net/core/request_sock.o

Hi, I read somewhere that strict_strtoul function was replaced by=20
some kstrtol function... So maybe somebody forgot to fix tsc2005=20
driver?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5775186.5qjUkLqLxT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRI/BAACgkQi/DJPQPkQ1KvdACfZFqrkHk907ubUeTMKSjjRmk6
eZ4AoJhsLryyPIMndmRoVCUT7/LWnp2A
=JfsC
-----END PGP SIGNATURE-----

--nextPart5775186.5qjUkLqLxT--
