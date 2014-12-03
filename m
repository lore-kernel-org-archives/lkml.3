Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaLCC1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:27:21 -0500
Received: from ozlabs.org ([103.22.144.67]:56957 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbaLCC1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:27:20 -0500
Date: Wed, 3 Dec 2014 13:27:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        <intel-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>
Subject: linux-next: manual merge of the drm tree with the drm-intel-fixes
 tree
Message-ID: <20141203132708.7423b7f8@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/F2uXJoqt_JDbq8onwOe7Skf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/F2uXJoqt_JDbq8onwOe7Skf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit b68362278af9
("drm/i915: More cautious with pch fifo underruns") from the
drm-intel-fixes tree and commit a72e4c9f9a11 ("drm/i915: Use dev_priv
in public intel_fifo_underrun.c functions") from the drm tree.

I fixed it up (I used the drm tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/F2uXJoqt_JDbq8onwOe7Skf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUfnUEAAoJEMDTa8Ir7ZwVCHoQAJHPp/kxcBac8+toI7ZQLwQc
tN5dOzKsuIW20Xr4CRndJUP2j7ZkpRSKTkBHGt8Td23fm9u3r1ys2kUJJKNYzuTb
BD56QJMWrC4Um7l/kjE8/p1wy+7aIwM4iZXCkJlvX9xsOfqwfJKN4q6vEvsJ6ZoX
2864VDBgwgfFVeWLqNzepOz2GxyaflsiFBUyPvsnbz8VXuW4BFXZzZXcwLb5y1Ek
6pM0fsC5tbBpOq8pcli71rFIMFGEZW25dV6mVd/cGVdHJkekgM0OrmaXe90+8XPk
UT88XsSIe+WnkjJtYtuNAzXrTuPKj7c0ieLJg/tM8Yd9XT+bOisScnQjxFP5a9Su
166du6f6cuqjujfP+4b3VvySCezkFRM/JgMpkK98qOkJgkTxt2IdZ6tHJcaSG6Zq
+onmMHbIBK3KzSeYFuUu5aMab6NXf1mJ+RSL8zc0ymx1Mpd5jPI3Vz3TCKgfAYBJ
Rt+/6iPs5EZy/y5n2cYqzIgUH/xBGO34uLW2Fp0ixzfD20ZWsL1ClxAYsXKqj7Um
vikTJQB+Ukl/jWBcMdRwINRNp0RNFnyXtTp+JY4A2fRKKCCpCQbdpMK6/s1Ctarh
2CRzRa6ge8Yhi6Rv1d0aYTltxXtm/B2fO37APH3QMMXdqaDNIB0ow7JDjWgsTDsW
Tgl8PIJdGyhdqaFmrdNo
=EX4d
-----END PGP SIGNATURE-----

--Sig_/F2uXJoqt_JDbq8onwOe7Skf--
