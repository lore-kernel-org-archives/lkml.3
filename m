Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3KKVal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:30:41 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:37449 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3KKVai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:30:38 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: gitorious v3.12-rc1-n900 tree
Date: Mon, 11 Nov 2013 22:30:30 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-13-generic; KDE/4.11.2; x86_64; ; )
Cc: sre@debian.org, sre@ring0.de, Jenny TC <jenny.tc@intel.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org
References: <201310240806.49340@pali> <20131105231241.GA5065@amd.pavel.ucw.cz> <20131106224241.GA5837@amd.pavel.ucw.cz>
In-Reply-To: <20131106224241.GA5837@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2550193.kUsk5gY3gV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311112230.32438@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2550193.kUsk5gY3gV
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 06 November 2013 23:42:41 Pavel Machek wrote:
> On Wed 2013-11-06 00:12:41, Pavel Machek wrote:
> > Hi!
> >=20
> > > > I tried pulling current linux-n900 tree from gitorious.
> > >=20
> > > Hi, use branch v3.12-rc5-n900 (not -rc1) and consider
> > > using rx51_defconfig.
> >=20
> > rx51_defconfig works for me, thanks.
> >=20
> > And here are fixes for the problems I hit... please apply,
> >=20
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> (the patch is still needed with v3.12-rc5-n900 branch).
> 									Pavel

Hi, thanks for patch. I commited it to v3.12-rc5-n900 branch.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2550193.kUsk5gY3gV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKBTHgACgkQi/DJPQPkQ1LqTgCgwQb/PMixnQYvVB7Jc+NeMj3R
zwEAni5dIIWrLrydp3czSZFd9Xug/Jxd
=yg26
-----END PGP SIGNATURE-----

--nextPart2550193.kUsk5gY3gV--
