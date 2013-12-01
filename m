Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab3LAJlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 04:41:46 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:40058 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3LAJln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 04:41:43 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] Staging: tidspbridge: make mmap root-only so it is not a security problem
Date: Sun, 1 Dec 2013 10:41:39 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        sre@ring0.de, omar.ramirez@copitl.com, tony@atomide.com,
        felipe.contreras@gmail.com, s-anna@ti.com, nm@ti.com, ohad@wizery.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org, nico@ngolde.de
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl> <20131130220553.GA1901@kroah.com> <20131130225822.GA26031@amd.pavel.ucw.cz>
In-Reply-To: <20131130225822.GA26031@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1519563.Q1RCQhSy4S";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312011041.40071@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1519563.Q1RCQhSy4S
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 30 November 2013 23:58:23 Pavel Machek wrote:
> On Sat 2013-11-30 14:05:53, Greg KH wrote:
> > On Sat, Nov 30, 2013 at 09:42:37PM +0100, Pavel Machek wrote:
> > > mmap in tidspbridge is missing range-checks. For now, make
> > > this interface root-only, so that it does not cause
> > > security problems.
> >=20
> > Please fix this properly and don't paper over the real
> > problem here.
>=20
> Well, if the driver is left uncompilable, I'm pretty sure it
> will bitrot.
>=20

If you want to compile tidspbridge driver, you need this patch:
https://gitorious.org/linux-n900/linux-n900/commit/b9adde42d5351467fa9d2811=
90213bb652499577

Removing BROKEN is not enough.

> I do have the hardware, but I'm pretty sure current mailine
> does not have enough support to boot Maemo, so it is non
> trivial for me to test changes here.
>=20

Use linux-n900 tree, there are patches also for tidspbridge
driver, so old maemo and new harmattan userspace can use it. But
HD videos not working yet (due to another problem, search for
OMAPFB: CMA allocation failures).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1519563.Q1RCQhSy4S
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKbBFQACgkQi/DJPQPkQ1KgFACggCR6BRJ929Z/3Tvlnlu9Mjc+
TWgAoMRkU8NMLYj8+L90NyIYmkBh1jZn
=G4x1
-----END PGP SIGNATURE-----

--nextPart1519563.Q1RCQhSy4S--
