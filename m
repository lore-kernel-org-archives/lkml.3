Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaFFCD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 22:03:26 -0400
Received: from ozlabs.org ([103.22.144.67]:36556 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbaFFCDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 22:03:18 -0400
Date: Fri, 6 Jun 2014 12:03:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the drm-intel-fixes tree
Message-ID: <20140606120315.6f2b1441@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/b8Lh2q197A66MO4=m6WJAJV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/b8Lh2q197A66MO4=m6WJAJV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the drm-intel-fixes tree, today's linux-next build
(x86_64 allmodconfig) failed like this:


drivers/gpu/drm/i915/intel_fbdev.c: In function 'intel_fb_initial_config':
drivers/gpu/drm/i915/intel_fbdev.c:392:4: error: implicit declaration of fu=
nction 'drm_get_connector_name' [-Werror=3Dimplicit-function-declaration]
    DRM_DEBUG_KMS("using first mode listed on connector %s\n",
    ^

This is just the error I reported yesterday against the drm and
drm-intel trees, but migrated to the drm-intel-fixes tree.  Your -fixes
tree shoudl really only contain stuff that depend on Linus' trees ...
but here it include all of yesterday's drm tree as well.

I have used the drm-intel-fixes tree from next-20140605 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/b8Lh2q197A66MO4=m6WJAJV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTkSFkAAoJEMDTa8Ir7ZwVv9IP/2Dogsm9mV8TNomIe1wCsF6o
ZgXuaO91VFY+b8x24JQAz3HfVzE6RLNHJTJdP+57B8F30zs1feoB3HZsNAtCtKLQ
Q3kC4FLF7OFXW8NZYnGLDpnpmUI2PiiEwIz8/p+nIY56NKI3oviP30SdBFqIKgOT
W9wiUtsyqG/jJeqQiRz4ex6Lw/NlfY9HY7mNTQra86/XllNvJgEYWZOf/0yWueDq
/CBQY1BCerEZj7BPZzhqso9CsUdT0Nixt4E765HPz9CjlFd3UwriR5aQwFA6F+hC
RUA38KVSpXOo0jdT+dSB1RpEtzuukC+LMo/SboL63PAnO9NwSzaRuWMYxuW2jwyR
1uBrrAeK1g0klu5yKrN6DJmyn0Lxa2maqisdSsj8rhbdn433c1iza5ULtj3BzIoC
VQ9i6mdPWylsz7DzQ8yI/YN0seV3LoRG/ROQU/5n2OSvr/dUyWik41B/MrfVlLHT
Ad0PybLw7Ynav5zouV2F+BoHjbgpmgoSy5+KkrjhWAOM+/3XexCtsOoDX7xE2E+N
m3hmNOVitqjkbAMCLzsdnjx8NmI1R2DkquiZSB37U7oVDdg1kpS74KyhmT48BJzW
4+yIN3jvaNktWfRWnNYj4ulW0UyGm+zit7WKeChvLtGbhw23w2SCR6Y3/I1W0XXo
HTDVtyulF0ANJV2ggzvi
=bDBd
-----END PGP SIGNATURE-----

--Sig_/b8Lh2q197A66MO4=m6WJAJV--
