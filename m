Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaETSKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:10:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62998 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaETSKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:10:37 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 1/2] platform: x86: dell-smo8800: Dell Latitude freefall driver (ACPI SMO8800/SMO8810)
Date: Tue, 20 May 2014 20:10:28 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500rc3-generic; KDE/4.13.0; x86_64; ; )
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-doc@vger.kernel.org,
        Sonal Santan <sonal.santan@gmail.com>
References: <1399114077-19314-1-git-send-email-pali.rohar@gmail.com> <201405201056.47726@pali> <20424.1400608961@turing-police.cc.vt.edu>
In-Reply-To: <20424.1400608961@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1898212.sOqooXxYZ6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201405202010.28868@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1898212.sOqooXxYZ6
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 20 May 2014 20:02:41 Valdis.Kletnieks@vt.edu wrote:
> On Tue, 20 May 2014 10:56:47 +0200, Pali Roh=C3=A1r said:
> > Hm? Which errors? Here is output from checkpacth:
> >=20
> > total: 0 errors, 0 warnings, 276 lines checked
> >=20
> > 0001-platform-x86-dell-smo8800-Dell-Latitude-freefall-dri.pa
> > tch has no obvious style problems and is ready for
> > submission.
> >=20
> > total: 0 errors, 0 warnings, 181 lines checked
> >=20
> > 0002-Documentation-Rename-hpfall.c-freefall.c-fixes-for-D.pa
> > tch has no obvious style problems and is ready for
> > submission.
>=20
> Hmm.. what tree are you building against?  I wonder if your
> checkpatch is a different version than mine (next-20140519).=20

I'm using up-to-date linus tree, git rev=20
60b5f90d0fac7585f1a43ccdad06787b97eda0ab

$ sha1sum scripts/checkpatch.pl
979ad287faf59d84d78825595ec97513a9d46fba  scripts/checkpatch.pl

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1898212.sOqooXxYZ6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlN7mpQACgkQi/DJPQPkQ1KNpgCffrmqNvosQTCLLJodoR1xx4M2
m7YAn08gnpKyJlk6mgJANKMXXq3BYoBE
=s8je
-----END PGP SIGNATURE-----

--nextPart1898212.sOqooXxYZ6--
