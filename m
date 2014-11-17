Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaKQDFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 22:05:04 -0500
Received: from ozlabs.org ([103.22.144.67]:40173 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaKQDFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 22:05:02 -0500
Date: Mon, 17 Nov 2014 14:04:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        <intel-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>
Subject: linux-next: manual merge of the drm tree with the drm-intel-fixes
 tree
Message-ID: <20141117140454.497aeee8@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mgd=kRmL2PUmbae+rvTxhQ+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mgd=kRmL2PUmbae+rvTxhQ+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_pm.c between commit 6bc55a67bd4b ("drm/i915:
drop WaSetupGtModeTdRowDispatch:snb") from the drm-intel-fixes tree and
commits (not sure which ones - the code seems to have been rearranged
quite a bit) from the drm tree.

I fixed it up (I applied the former patch by hand to the file from the
drm tree) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/mgd=kRmL2PUmbae+rvTxhQ+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUaWXbAAoJEMDTa8Ir7ZwVhRoP/3Mxsw5mdL4gEqqZ65e0pxM5
YdS5174Jh/kdIDA46/ibYpuTIyM/uA2zxu64hWLxJVUI9CCLogR83m2mrufxDuRY
14DkbaSY0sWFc1ZAOS2LVq3b5INWtLG1wVkHQckdyy0Af5rKpgA28/IOlTh4wdmv
5QTBsPkAEifyXOFJcyUZiJdkxzwptMU4OJS3sFbA7czWs8k/9uZ/Q4ECytMZkrGd
XW9HEPTkjMROu73oBYVqv2Mtfd6zDlVVCEFeRpIE/NWqAN1VHdfxpjTKstiAW0u/
ptGHygM9cIoR3SBlqtIwOlBo5vP4jeyfCv+YzXcCgV5H14piKhDFSnOsC9NlxlZC
5xEFYAdaWwLe7rJKzQBsD92oRw7Fn9f8RXIjxvaGlhXP7pNlFcYoA3SVWSz06c5t
kkVtYep09/sIFzuB55Z7Xfs8P6SV2eTk6KzaxU8aGfPs6nz58NGhmqqdVKuSJclj
zkYXE14MTj5R78zsxGSSAnwRbvm/FDfg4tJxS/ytuUG5RchdomtONfK8gw8wz1GA
39uPnld8P2n22iC+urSbP0vZv/goolIh3nLukWbENWgpkvgP4+5VM0E9wD2U8CnJ
EEfbyFDcYx56YyR65b9kcZd/sEMKDy0RrfpeV2tEI+Si6BZ2ZVynn/xhHOOxcc/L
zBzbRQo7siJ6tWOh5+FA
=aJur
-----END PGP SIGNATURE-----

--Sig_/mgd=kRmL2PUmbae+rvTxhQ+--
