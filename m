Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaGGSPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:15:39 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:43460 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaGGSPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:15:37 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2] Documentation: Rename hpfall.c => freefall.c, fixes for Dell
Date: Mon, 7 Jul 2014 20:15:32 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500-generic; KDE/4.13.2; x86_64; ; )
Cc: Matthew Garrett <matthew.garrett@nebula.com>, Pavel Machek <pavel@ucw.cz>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Sonal Santan <sonal.santan@gmail.com>
References: <1399114077-19314-3-git-send-email-pali.rohar@gmail.com> <1402473727-5464-1-git-send-email-pali.rohar@gmail.com> <53AF7601.5000205@infradead.org>
In-Reply-To: <53AF7601.5000205@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2521090.aZ6eBgeppJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201407072015.32497@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2521090.aZ6eBgeppJ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello Randy, sorry but now I do not have any free time...

On Sunday 29 June 2014 04:12:17 Randy Dunlap wrote:
> Hi,
>=20
> This should really be done as 2 separate patches:
> One to move/rename the file and one to make the
> changes/additions to it for DELL.
>=20
> Can you resend it as 2 patches like that, please?
>=20
> Thanks... and sorry for the delay.
>=20
> On 06/11/14 01:02, Pali Roh=C3=A1r wrote:
> > Dell kernel driver dell-smo8800 provides same freefall
> > interface as hp_accel so program hpfall.c works also on
> > Dell laptops. So rename it to freefall.c.
> >=20
> > Dell driver does not provide hp::hddprotect led so make sure
> > that freefall.c works also if hp::hddprotect does not exist
> > in sysfs.
> >=20
> > Additionally write info to syslog.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > Cc: Sonal Santan <sonal.santan@gmail.com>
> > ---
> > Changes since v1:
> > * Fixed warnings: Missing a blank line after declarations
> > ---
> >=20
> >  Documentation/laptops/00-INDEX   |    4 +-
> >  Documentation/laptops/freefall.c |  177
> >  ++++++++++++++++++++++++++++++++++++++
> >  Documentation/laptops/hpfall.c   |  146
> >  ------------------------------- 3 files changed, 179
> >  insertions(+), 148 deletions(-) create mode 100644
> >  Documentation/laptops/freefall.c delete mode 100644
> >  Documentation/laptops/hpfall.c

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2521090.aZ6eBgeppJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlO648QACgkQi/DJPQPkQ1ITEgCeIrB2OHagNnnLdOQZEuQrS8sp
wDQAoLLsc2D/s3gf+InJZtD4Bmhd1ACk
=B9C4
-----END PGP SIGNATURE-----

--nextPart2521090.aZ6eBgeppJ--
