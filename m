Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab3GZDLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:11:02 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40360 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab3GZDLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:11:00 -0400
Date: Fri, 26 Jul 2013 13:10:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: linux-next: manual merge of the drm-intel tree with the
 drm-intel-fixes tree
Message-Id: <20130726131057.e0afca6b0771f334111214dd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Jul_2013_13_10_57_+1000_lahZHl1HmTTB4YG8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jul_2013_13_10_57_+1000_lahZHl1HmTTB4YG8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/i915_dma.c between commit 14c5cec5d0cd ("drm/i915:
initialize gt_lock early with other spin locks") from the drm-intel-fixes
tree and commit 907b28c56ea4 ("drm/i915: Colocate all GT access routines
in the same file") from the drm-intel tree.

I fixed it up (using the drm-intel tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Jul_2013_13_10_57_+1000_lahZHl1HmTTB4YG8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR8ejBAAoJEECxmPOUX5FER9sP/3GOnPi0rOaP7yN09Tp2QlM2
ch4VXEuJNN05rCLV2VX8m/sVxFFiM+RfK+dXMrCxJjSH9Wkb5XdSV5ZtRx4CYIqU
VISCCIAEebbQEAl2Hj7aJ0JrLh4r/5Pr67CtAKyRe10bbfpYyEwqyQOeMwxJK/8J
6hK+mejM8cso+muG2vV0GPq2EzuLrbTgHHJBNmoUND3mM+PlOTb+AeErGKGQV2t3
b0eYKF2WpGHJnDjIpzg8CI6p7oKrhrCzl9EjclURRu3vnsEBnnGoOvL87cyyfw9P
zQBUtkN89mOIgWHw/BXh4XPK7xPDzpfzVBMI+kLh4vz0H6WyDXo7yJMKtqr/UEAs
bONyIBDju+JOkhYB2a1dMr7wq6d1qUo2ZgK6pQM0nkUfqyl/31vhflWHrpOQagT5
7YodEbzaOY5wxWpEocqhDVejms4BvFoYqgw3VxmZI/Vminqtq74OVjNWE/7sLX9a
LcvGjMJtuuYKAuTMeAgvdxtl344GT9MkpysCgbAaToSv/rbXePj9QoInGKwI8flr
pK3jAwaAMjbWZGMttrdnuKvhDr9QVhhbn8oJ7GoxDr3J8asBj99kF4NDBOcFfi5a
ozySdN7BqsZYPg5SXB5a/34Zgae4XDWobgz0RYoD5AMjeZs/SFO2j7byxWH5B3wi
mbesQh7LoOeFw/p0w6HO
=5jmo
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jul_2013_13_10_57_+1000_lahZHl1HmTTB4YG8--
