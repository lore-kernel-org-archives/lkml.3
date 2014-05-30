Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbaE3QPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:15:17 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46388 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbaE3QPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:15:15 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range() instead of msleep()
Date: Fri, 30 May 2014 18:15:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500rc3-generic; KDE/4.13.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Marcel Holtmann <marcel@holtmann.org>,
        Miguel Oliveira <cmroliv@gmail.com>, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com> <20140530123023.GA10549@amd.pavel.ucw.cz> <20140530155959.GA10682@kroah.com>
In-Reply-To: <20140530155959.GA10682@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6680612.DriBYmdZNk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201405301815.10811@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6680612.DriBYmdZNk
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Friday 30 May 2014 17:59:59 Greg KH wrote:
> On Fri, May 30, 2014 at 02:30:23PM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > >> Creating this patch for the Eudyptula Challenge.
> > > >> Replaced msleep() for a delay < 20ms with a
> > > >> usleep_range() between 10000us and 15000us. Also
> > > >> inserted a blank line after adeclaration.
> > > >=20
> > > > So you are changing timings without testing. Plus,
> > > > burning CPU power instead of sleeping.
> > > >=20
> > > > Seems you'll need another patch for the challenge :-).
> > >=20
> > > I actually wonder if anybody is seriously working on this
> > > driver. My concern with the staging drivers has always
> > > been that we are quick with merging them when the work on
> > > getting them into upstream shape is actually hard.
> > > However reality is once they are in staging nobody is
> > > doing the work to clean them up and fix the issues.
> >=20
> > There is active work on merging n900 changes.
>=20
> Really?  Where?
>=20

You can look at elinux wiki where is table how process is going:
http://elinux.org/N900

Also look at planed future list and its progress:
http://elinux.org/N900/Changelog

You can see that drivers are including step by step.

> > And no, it does not progress as quickly as I'd like, but
> > we'll get there. It is also requirement for n900 FM radio
> > receiving...
> >=20
> > > Greg, instead of wasting our time with this, can we just
> > > remove this driver from staging.
> >=20
> > Please don't.
>=20
> As there has not been any real work on it since it has been
> merged, I don't see why I shouldn't remove it.  If you do get
> some work done on it, you can always revert the removal and
> continue on.  But the existance of code in staging that is
> not progressing forward at all is something that I don't like
> at all, and will be doing a large sweep of soon to remove.
>=20
> thanks,
>=20
> greg k-h

Just look how much time took to include my patch for radio-
bcm2048 (fm radio part of this chip) which fixing wrong overflow=20
check. I sent it at the end of December and... yes it is still=20
not included in linus tree. Now it is somethere in media tree and=20
probably will be pulled in next merge window.

This means that it takes about half of year to include patches=20
for these drivers.

So why now you want to very quickly remove this driver from=20
staging but you did not wanted to take my above patch?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6680612.DriBYmdZNk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlOIro4ACgkQi/DJPQPkQ1L55QCgtBoF9oRcml+Z7PcHOC5ZJdJo
vEwAn2V551ZKbrqx6e5hq0QzKvUySevC
=nojx
-----END PGP SIGNATURE-----

--nextPart6680612.DriBYmdZNk--
