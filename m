Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaF0TIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:08:17 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42268 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaF0TIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:08:15 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH v2] Documentation: Rename hpfall.c => freefall.c, fixes for Dell
Date: Fri, 27 Jun 2014 21:08:10 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500-generic; KDE/4.13.2; x86_64; ; )
Cc: Randy Dunlap <rdunlap@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Sonal Santan <sonal.santan@gmail.com>
References: <1399114077-19314-3-git-send-email-pali.rohar@gmail.com> <20140614085328.GC15326@Nokia-N900> <201406161355.03998@pali>
In-Reply-To: <201406161355.03998@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2965064.AjOTh0FVDk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201406272108.10901@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2965064.AjOTh0FVDk
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 16 June 2014 13:55:03 Pali Roh=C3=A1r wrote:
> On Saturday 14 June 2014 10:53:29 Pavel Machek wrote:
> > On Wed 2014-06-11 10:02:07, Pali Roh?r wrote:
> > > Dell kernel driver dell-smo8800 provides same freefall
> > > interface as hp_accel so program hpfall.c works also on
> > > Dell laptops. So rename it to freefall.c.
> > >=20
> > > Dell driver does not provide hp::hddprotect led so make
> > > sure that freefall.c works also if hp::hddprotect does
> > > not exist in sysfs.
> > >=20
> > > Additionally write info to syslog.
> > >=20
> > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > Cc: Sonal Santan <sonal.santan@gmail.com>
> > > ---
> > > Changes since v1:
> > > * Fixed warnings: Missing a blank line after declarations
> > > ---
> > >=20
> > >  Documentation/laptops/00-INDEX   |    4 +-
> > >  Documentation/laptops/freefall.c |  177
> > >  ++++++++++++++++++++++++++++++++++++++
> > >  Documentation/laptops/hpfall.c   |  146
> > >  ------------------------------- 3 files changed, 179
> > >  insertions(+), 148 deletions(-) create mode 100644
> > >  Documentation/laptops/freefall.c delete mode 100644
> > >  Documentation/laptops/hpfall.c
> >=20
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> >=20
> > 						Pavel
>=20
> Randy, Matthew: PING
>=20
> first patch which implementing dell-smo8800.ko was merged, but
> this patch which updating documentation and fall daemon *not*.

PING.

What is with this patch? Why was still not set to Linus in doc or=20
platform pull request?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2965064.AjOTh0FVDk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlOtwRoACgkQi/DJPQPkQ1JfHQCfV+6xMdSIWowN/KrOL3iNzgeH
el8AnjK4loQXhwbbtcXCnQ6wCYBuUJal
=bvc0
-----END PGP SIGNATURE-----

--nextPart2965064.AjOTh0FVDk--
