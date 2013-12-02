Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab3LBUvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:51:16 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34510 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3LBUvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:51:11 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] media: Add BCM2048 radio driver
Date: Mon, 2 Dec 2013 21:51:07 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
        Nils Faerber <nils.faerber@kernelconcepts.de>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>
References: <1381847218-8408-1-git-send-email-pali.rohar@gmail.com> <201310262245.03279@pali> <52778780.6060802@xs4all.nl>
In-Reply-To: <52778780.6060802@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart86654926.erhikFO6YK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312022151.07599@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart86654926.erhikFO6YK
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 04 November 2013 12:39:44 Hans Verkuil wrote:
> Hi Pali,
>=20
> On 10/26/2013 10:45 PM, Pali Roh=C3=A1r wrote:
> > On Saturday 26 October 2013 22:22:09 Hans Verkuil wrote:
> >>> Hans, so can it be added to drivers/staging/media tree?
> >>=20
> >> Yes, that is an option. It's up to you to decide what you
> >> want. Note that if no cleanup work is done on the staging
> >> driver for a long time, then it can be removed again.
> >>=20
> >> Regards,
> >>=20
> >>     Hans
> >=20
> > Ok, so if you can add it to staging tree. When driver will
> > be in mainline other developers can look at it too. Now
> > when driver is hidden, nobody know where to find it... You
> > can see how upstream development for Nokia N900 HW going
> > on: http://elinux.org/N900
>=20
> Please check my tree:
>=20
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/h
> eads/bcm
>=20
> If you're OK, then I'll queue it for 3.14 (it's too late for
> 3.13).
>=20
> Regards,
>=20
> 	Hans

Hi, sorry for late reply. I looked into your tree and difference=20
is that you only removed "linux/slab.h" include. So it it is not=20
needed, then it is OK.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart86654926.erhikFO6YK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKc8rsACgkQi/DJPQPkQ1KZYACfe6LqwqpLIcqHjek+R6MeIELl
21YAnRX+QZzH/U8QdK0DS+HGHj92cPXp
=ot2P
-----END PGP SIGNATURE-----

--nextPart86654926.erhikFO6YK--
