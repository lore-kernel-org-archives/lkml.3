Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaLXMGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:06:24 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49764 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaLXMGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:06:23 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Linux 3.19-rc1: i915.ko error messages at boot
Date: Wed, 24 Dec 2014 13:06:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.19.0-031900rc1-generic; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1547634.xRJP02Oadi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412241306.19359@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1547634.xRJP02Oadi
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

lspci output:
00:02.0 VGA compatible controller [0300]: Intel Corporation 4th Gen Core Pr=
ocessor Integrated Graphics=20
Controller [8086:0416] (rev 06)

dmesg output:
[    2.379847] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the=20
i915.mmio_debug=3D1 to debug this problem.
[    2.379847] [drm:intel_uncore_check_errors [i915]] *ERROR* Unclaimed reg=
ister before interrupt
[    2.379868] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the=20
i915.mmio_debug=3D1 to debug this problem.
[    2.379869] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the=20
i915.mmio_debug=3D1 to debug this problem.
[    2.430637] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the=20
i915.mmio_debug=3D1 to debug this problem.<3>[    2.430649] [drm:intel_unco=
re_check_errors [i915]] *ERROR*=20
Unclaimed register before interrupt
[    2.430756] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the=20
i915.mmio_debug=3D1 to debug this problem.
[    2.430817] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the=20
i915.mmio_debug=3D1 to debug this problem.[drm:hsw_unclaimed_reg_detect.isr=
a.6 [i915]] *ERROR* Unclaimed register=20
detected. Please use the i915.mmio_debug=3D1 to debug this problem.
[    2.430948] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the=20
i915.mmio_debug=3D1 to debug this problem.[drm:hsw_unclaimed_reg_detect.isr=
a.6 [i915]] *ERROR* Unclaimed register=20
detected. Please use the i915.mmio_debug=3D1 to debug this problem.
[    2.619114] [drm:intel_uncore_check_errors [i915]] *ERROR* Unclaimed reg=
ister before interrupt
[    2.619213] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the=20
i915.mmio_debug=3D1 to debug this problem.
[    2.619275] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the=20
i915.mmio_debug=3D1 to debug this problem.[drm:hsw_unclaimed_reg_detect.isr=
a.6 [i915]] *ERROR* Unclaimed register=20
detected. Please use the i915.mmio_debug=3D1 to debug this problem.
[    2.626522] [drm:intel_uncore_check_errors [i915]] *ERROR* Unclaimed reg=
ister before interrupt
[    2.626616] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the=20
i915.mmio_debug=3D1 to debug this problem.
[    2.626678] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the=20
i915.mmio_debug=3D1 to debug this problem.<6>[    2.633412] AVX2 version of=
 gcm_enc/dec engaged.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1547634.xRJP02Oadi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSarDsACgkQi/DJPQPkQ1IOjgCgmLqwtv8TUhj/sE5MqH76XU1o
pwgAn2JeqYc0HpRQWlV77OHHIyGKymAr
=uVdy
-----END PGP SIGNATURE-----

--nextPart1547634.xRJP02Oadi--
