Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3LENVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:21:04 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:35736 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab3LENVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:21:01 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] media: Add BCM2048 radio driver
Date: Thu, 5 Dec 2013 14:20:56 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
        Nils Faerber <nils.faerber@kernelconcepts.de>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Pavel Machek <pavel@ucw.cz>, sre@ring0.de, aaro.koskinen@iki.fi
References: <1381847218-8408-1-git-send-email-pali.rohar@gmail.com> <201312022151.07599@pali> <52A030BE.7040709@xs4all.nl>
In-Reply-To: <52A030BE.7040709@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4391473.OPzRdpZXxa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312051420.56852@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4391473.OPzRdpZXxa
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 05 December 2013 08:52:30 Hans Verkuil wrote:
> On 12/02/2013 09:51 PM, Pali Roh=C3=A1r wrote:
> > On Monday 04 November 2013 12:39:44 Hans Verkuil wrote:
> >> Hi Pali,
> >>=20
> >> On 10/26/2013 10:45 PM, Pali Roh=C3=A1r wrote:
> >>> On Saturday 26 October 2013 22:22:09 Hans Verkuil wrote:
> >>>>> Hans, so can it be added to drivers/staging/media tree?
> >>>>=20
> >>>> Yes, that is an option. It's up to you to decide what you
> >>>> want. Note that if no cleanup work is done on the staging
> >>>> driver for a long time, then it can be removed again.
> >>>>=20
> >>>> Regards,
> >>>>=20
> >>>>     Hans
> >>>=20
> >>> Ok, so if you can add it to staging tree. When driver will
> >>> be in mainline other developers can look at it too. Now
> >>> when driver is hidden, nobody know where to find it... You
> >>> can see how upstream development for Nokia N900 HW going
> >>> on: http://elinux.org/N900
> >>=20
> >> Please check my tree:
> >>=20
> >> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/ref
> >> s/h eads/bcm
> >>=20
> >> If you're OK, then I'll queue it for 3.14 (it's too late
> >> for 3.13).
> >>=20
> >> Regards,
> >>=20
> >> 	Hans
> >=20
> > Hi, sorry for late reply. I looked into your tree and
> > difference is that you only removed "linux/slab.h" include.
> > So it it is not needed, then it is OK.
>=20
> I *added* slab.h :-)
>=20

Right, I looked at reverse diff :-)

> Anyway, I've posted the pull request. Please note, if you want
> to avoid having this driver be removed again in the future,
> then you (or someone else) should work on addressing the
> issues in the TODO file I added.
>=20
> Regards,
>=20
> 	Hans

Ok. CCing other people who works with n900 kernel.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4391473.OPzRdpZXxa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKgfbgACgkQi/DJPQPkQ1KFcgCcDfRd1qPjKNFaQbLQnsFYHayu
gpkAnRvMP6Kon53xxaYo547H79UX4Lih
=jk1Z
-----END PGP SIGNATURE-----

--nextPart4391473.OPzRdpZXxa--
