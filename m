Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaLTJKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 04:10:31 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59227 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaLTJKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 04:10:23 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH 0/3] dell-wmi: Don't send unneeded keypresses
Date: Sat, 20 Dec 2014 10:10:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        mjg59@srcf.ucam.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com> <201412052207.35676@pali> <20141203180329.GB20370@vmdeb7>
In-Reply-To: <20141203180329.GB20370@vmdeb7>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1657903.OEBXyi7mYS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412201010.18151@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1657903.OEBXyi7mYS
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 03 December 2014 19:03:37 Darren Hart wrote:
> On Fri, Dec 05, 2014 at 10:07:35PM +0100, Pali Roh=C3=A1r wrote:
> > On Friday 05 December 2014 21:41:22 Pavel Machek wrote:
> > > On Fri 2014-12-05 21:31:34, Pali Roh=C3=A1r wrote:
> > > > On Wednesday 03 December 2014 14:34:32 Darren Hart wrote:
> > > > > On Thu, Dec 04, 2014 at 12:16:20AM +0100, Gabriele
> > > > > Mazzotta
> > > >=20
> > > > wrote:
> > > > > > Currently dell-wmi reports keypresses for WMI events
> > > > > > that are notifications of changes performed by the
> > > > > > BIOS. This patch series make sure that no keypresses
> > > > > > are sent for those events so that nothing is done
> > > > > > from userspace.
> > > > > >=20
> > > > > > Gabriele Mazzotta (3):
> > > > > >   dell-wmi: Use appropriate keycode for radio state
> > > > > >   changes dell-wmi: Don't report keypresses for
> > > > > >   radio state changes
> > > > >=20
> > > > > Merged into one patch, queued.
> > > > >=20
> > > > > >   dell-wmi: Don't report keypresses on keybord
> > > > > >   illumination change
> > > > >=20
> > > > > Queued.
> > > > >=20
> > > > > Thanks Gabriele.
> > > >=20
> > > > Darren, what do you think about sending patch into
> > > > stable kernel?
> > >=20
> > > I'd suggest against that. -stable is for "serious" bugs,
> > > and we don't want to change this kind of behaviour in
> > > -stable kernel.
> > >=20
> > > 								Pavel
> >=20
> > Ok, I agree that it is subjective how serious it is...
> > Just to remind that patch fixing problem described in
> >=20
> > http://www.spinics.net/lists/platform-driver-x86/msg05922.ht
> > ml
> > http://www.spinics.net/lists/platform-driver-x86/msg05924.h
> > tml
>=20
> I don't have any objection to sending this back to stable.
> Stable is for fixing REAL bugs, as opposed to theorhetical
> races, etc. This is a "real" bug.
>=20
> As to not chaning behavior, if it's OK for mainline, it's OK
> for stable. At least that is my understanding of it. Folks
> are free to verify with Greg if they disagree.

Darren, so how you decided? Now when patches are in linus tree,=20
are you going to send them to stable tree?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1657903.OEBXyi7mYS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSVPPoACgkQi/DJPQPkQ1LAFgCffZ3/2tVeqDMZOUMwfruWkPPg
BdwAoIFtT9B82D8tXjf4RwmXcA6nqIUk
=6BDc
-----END PGP SIGNATURE-----

--nextPart1657903.OEBXyi7mYS--
