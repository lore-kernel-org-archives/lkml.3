Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab3DQQiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:38:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34707 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3DQQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:38:54 -0400
Message-ID: <1366216723.20385.7.camel@fourier>
Subject: Re: [PATCH] [media] uvcvideo: quirk PROBE_DEF for Dell Studio /
 OmniVision webcam
From: Kamal Mostafa <kamal@canonical.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Wed, 17 Apr 2013 09:38:43 -0700
In-Reply-To: <3233904.U6nm1cedXx@avalon>
References: <1366052511-27284-1-git-send-email-kamal@canonical.com>
	 <3233904.U6nm1cedXx@avalon>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ncPWVMVYS8hTjMf40P38"
X-Mailer: Evolution 3.6.2-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ncPWVMVYS8hTjMf40P38
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-04-17 at 01:05 +0200, Laurent Pinchart wrote:
> Hi Kamal,
>=20
> On Monday 15 April 2013 12:01:51 Kamal Mostafa wrote:
> > BugLink: https://bugs.launchpad.net/bugs/1168430
> >=20
> > OminiVision webcam 0x05a9:0x264a (in Dell Studio Hybrid 140g) needs the
> > same UVC_QUIRK_PROBE_DEF as other OmniVision model to be recognized
> > consistently.
> >=20
> > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
>=20
> Thank you for the patch.
>=20
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>=20
> I've taken the patch in my tree and will submit it upstream for v3.11.
>=20
> Could you please try to get the full 'lsusb -v -d 05a9:264a' output from =
the=20
> bug reporter ?


Thanks Laurent.  The requested lsusb dump is now available at
https://launchpadlibrarian.net/137633994/lsusb-omnivision-264a.txt

 -Kamal


--=-ncPWVMVYS8hTjMf40P38
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJRbtATAAoJEHqwmdxYrXhZmJwP/30mqpAVerfg7aOFfdTRz2jr
mtWLbrvqC53ng5O/brKwrcfvf/UuNrFPFDOVl27wdQO+o5E6UOC0nKsNGon5P8aS
gFSTHmtSAdo69DqW2ncvb1L3qeJHJOww/706ozfdhpLniL6lLOyKtTrHqsTsjQde
3WbQk9ZQD73jvMf4w9ATutFKCJeOV4DEQtW/vpJ3ZXvO2pZfRbkCLVUtiJFAbd5J
YnKMEUZWI/7bBHRB+/W/GYeV4ILMAm43J4xvTPWxhfXeduZAVMA6eGPbY/WjmWA2
wN6nlN7ZWx8WXXe93Yu/PW9UmVBGxNyLvySrU18MNs2rNzuDIkczMBBvoRQmHN0p
j0SD4lm+WLKgF9TMyv4w+lf70kVPouY3KCGsathqDBlUOXc7yR6yPniKXbOnO3jw
q2CRh6kYktwy1j4HHub1WVq7OHNWIaANIOgBFq0w/x6sxF4kIuzFk14/kfriokFs
uuSU5L1QC/OgbTMCBSAeLGRU0zmKyUL45ZZeyhCv1sAqvWLjAOBGnD4spsHSrE/Y
SHnJrkJA7grS2d57OmRojohaU5zAmP/Yk0kn954fjsZ9qrpRjQ/M0O/BnK20XtPY
cM/89cgkKYr2dCvA3gfD5ad+CsHrOtkur/mtkqF4LQq47MaJ8LXfOhzCGZTHXs12
ckJ+4IIfGrcdCu4MtVcY
=WUn6
-----END PGP SIGNATURE-----

--=-ncPWVMVYS8hTjMf40P38--

