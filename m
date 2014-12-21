Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaLUJGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 04:06:31 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:52426 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaLUJGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 04:06:22 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/2] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Sun, 21 Dec 2014 10:06:16 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Steven Honeyman <stevenhoneyman@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <CABz95_DzfVFbnQL_8QD=3qdswUYskGsS4k==bgMT596rKHOkuw@mail.gmail.com> <5495BAF5.9000909@roeck-us.net>
In-Reply-To: <5495BAF5.9000909@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3788953.acQ28Ndonm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412211006.16859@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3788953.acQ28Ndonm
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 20 December 2014 19:07:49 Guenter Roeck wrote:
> On 12/20/2014 09:27 AM, Steven Honeyman wrote:
> > On 20 December 2014 at 17:20, Guenter Roeck <linux@roeck-
us.net> wrote:
> >> I would think that it should be relatively safe
> >> to assume that the first fan always exists
> >=20
> > That would be a bad idea, as this is definitely not the
> > case:
> >=20
> > i8k-virtual-0
> > Adapter: Virtual device
> > fan2:        3181 RPM
> > CPU:          +43.0=C2=B0C
> > Ambient:      +42.0=C2=B0C
> > SODIMM:       +36.0=C2=B0C
>=20
> Well, then he'll have to loop through fans until finding one
> which exists.
>=20
> Guenter

Ok, I will send new version of patch.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3788953.acQ28Ndonm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSWjYgACgkQi/DJPQPkQ1Ky2wCbBOL1UHtkYxQm021dNPFdOkJN
ajQAniBSz+mFG+5bDFINgAeqL9PW5Bv5
=2hmr
-----END PGP SIGNATURE-----

--nextPart3788953.acQ28Ndonm--
