Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3JZUpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 16:45:11 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:53968 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3JZUpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 16:45:07 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [PATCH] media: Add BCM2048 radio driver
Date: Sat, 26 Oct 2013 22:45:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        "Eero Nurkkala" <ext-eero.nurkkala@nokia.com>,
        "Nils Faerber" <nils.faerber@kernelconcepts.de>,
        "Joni Lapilainen" <joni.lapilainen@gmail.com>,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>
References: <1381847218-8408-1-git-send-email-pali.rohar@gmail.com> <201310262204.33674@pali> <2099a1da904181598455905c79a7921d.squirrel@webmail.xs4all.nl>
In-Reply-To: <2099a1da904181598455905c79a7921d.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4450933.6dzIUJ44KZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201310262245.03279@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4450933.6dzIUJ44KZ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 26 October 2013 22:22:09 Hans Verkuil wrote:
> > Hans, so can it be added to drivers/staging/media tree?
>=20
> Yes, that is an option. It's up to you to decide what you
> want. Note that if no cleanup work is done on the staging
> driver for a long time, then it can be removed again.
>=20
> Regards,
>=20
>     Hans
>=20

Ok, so if you can add it to staging tree. When driver will be in=20
mainline other developers can look at it too. Now when driver is=20
hidden, nobody know where to find it... You can see how upstream=20
development for Nokia N900 HW going on: http://elinux.org/N900

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4450933.6dzIUJ44KZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlJsKc8ACgkQi/DJPQPkQ1KDdQCaAgtyXt6RJ4GhtICsHjoBihN7
kwIAn2v6wzeDPEdBWwwV7rWFH+5gCnSZ
=eTmu
-----END PGP SIGNATURE-----

--nextPart4450933.6dzIUJ44KZ--
