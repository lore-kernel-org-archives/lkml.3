Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaLEUbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 15:31:39 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53995 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaLEUbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 15:31:37 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH 0/3] dell-wmi: Don't send unneeded keypresses
Date: Fri, 5 Dec 2014 21:31:34 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>, mjg59@srcf.ucam.org,
        pavel@ucw.cz, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com> <20141203133431.GG75099@vmdeb7>
In-Reply-To: <20141203133431.GG75099@vmdeb7>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5085208.aQI5Aj11Yf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412052131.34455@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5085208.aQI5Aj11Yf
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 03 December 2014 14:34:32 Darren Hart wrote:
> On Thu, Dec 04, 2014 at 12:16:20AM +0100, Gabriele Mazzotta=20
wrote:
> > Currently dell-wmi reports keypresses for WMI events that
> > are notifications of changes performed by the BIOS.
> > This patch series make sure that no keypresses are sent for
> > those events so that nothing is done from userspace.
> >=20
> > Gabriele Mazzotta (3):
> >   dell-wmi: Use appropriate keycode for radio state changes
> >   dell-wmi: Don't report keypresses for radio state changes
>=20
> Merged into one patch, queued.
>=20
> >   dell-wmi: Don't report keypresses on keybord illumination
> >   change
>=20
> Queued.
>=20
> Thanks Gabriele.

Darren, what do you think about sending patch into stable kernel?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5085208.aQI5Aj11Yf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSCFiYACgkQi/DJPQPkQ1JOOgCeL2gHdDFO0WaRHPiORiGZyrwr
hLEAn0K3u/Z7iIc8ccwW/3+RoFK7/ntu
=HXYK
-----END PGP SIGNATURE-----

--nextPart5085208.aQI5Aj11Yf--
