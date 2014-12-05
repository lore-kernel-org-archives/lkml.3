Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaLEVHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:07:40 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44463 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLEVHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:07:38 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/3] dell-wmi: Don't send unneeded keypresses
Date: Fri, 5 Dec 2014 22:07:35 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Darren Hart <dvhart@infradead.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>, mjg59@srcf.ucam.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com> <201412052131.34455@pali> <20141205204122.GA11772@amd>
In-Reply-To: <20141205204122.GA11772@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart15933937.J3mFbyvu6I";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412052207.35676@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart15933937.J3mFbyvu6I
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 05 December 2014 21:41:22 Pavel Machek wrote:
> On Fri 2014-12-05 21:31:34, Pali Roh=C3=A1r wrote:
> > On Wednesday 03 December 2014 14:34:32 Darren Hart wrote:
> > > On Thu, Dec 04, 2014 at 12:16:20AM +0100, Gabriele
> > > Mazzotta
> >=20
> > wrote:
> > > > Currently dell-wmi reports keypresses for WMI events
> > > > that are notifications of changes performed by the
> > > > BIOS. This patch series make sure that no keypresses
> > > > are sent for those events so that nothing is done from
> > > > userspace.
> > > >=20
> > > > Gabriele Mazzotta (3):
> > > >   dell-wmi: Use appropriate keycode for radio state
> > > >   changes dell-wmi: Don't report keypresses for radio
> > > >   state changes
> > >=20
> > > Merged into one patch, queued.
> > >=20
> > > >   dell-wmi: Don't report keypresses on keybord
> > > >   illumination change
> > >=20
> > > Queued.
> > >=20
> > > Thanks Gabriele.
> >=20
> > Darren, what do you think about sending patch into stable
> > kernel?
>=20
> I'd suggest against that. -stable is for "serious" bugs, and
> we don't want to change this kind of behaviour in -stable
> kernel.
>=20
> 								Pavel

Ok, I agree that it is subjective how serious it is...
Just to remind that patch fixing problem described in

http://www.spinics.net/lists/platform-driver-x86/msg05922.html
http://www.spinics.net/lists/platform-driver-x86/msg05924.html

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart15933937.J3mFbyvu6I
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSCHpcACgkQi/DJPQPkQ1KVUgCglrWCmHBBLq13mOX/X49VreO7
s3wAoJgl2NZjiUsfFiFnaODU6LcIwhJu
=HVIl
-----END PGP SIGNATURE-----

--nextPart15933937.J3mFbyvu6I--
