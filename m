Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab3GZDOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:14:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60803 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab3GZDOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:14:31 -0400
Date: Fri, 26 Jul 2013 13:14:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: linux-next: manual merge of the drm-intel tree with the
 drm-intel-fixes tree
Message-Id: <20130726131427.31a36ca15eef6a19a4e9ca9a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Jul_2013_13_14_27_+1000_RFhC13xyzAXUJlUt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jul_2013_13_14_27_+1000_RFhC13xyzAXUJlUt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_pm.c between commit 14c5cec5d0cd ("drm/i915:
initialize gt_lock early with other spin locks") from the drm-intel-fixes
tree and commit 907b28c56ea4 ("drm/i915: Colocate all GT access routines
in the same file") from the drm-intel tree.

I fixed it up (using the drm-intel tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Jul_2013_13_14_27_+1000_RFhC13xyzAXUJlUt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR8emTAAoJEECxmPOUX5FEg8YP/258suZVvIRE4ELg/8gjBRqB
5fqAVqgiLSMPR0M+PNL9+f4e0jsslIFnkUVhEb6ITqizwfA45JBf26MHEfrWv+yd
fWWn0yxVVFUsNb+hmkSh0FDLvHC4yM77QwZqhufJdxXPhyl5cKm0N0oUhuAM9IYG
blZB8ql3XAMfMETA+mUvoJPGEraZvhkOQ5DQXbD8aLVf4dsChsLflKs1EhkZhzE0
ex22Z9gGocW9rr+Q5Ec5pwhVZW5lIogPYV0UhAuYSfAzGc9ICKy5zuI4gic80xZJ
HIyYqFvFlImz8/U9KokSWN4IO4oMvbS48bKCqbC5xgdbcJ5B0b6VeGdxA8NjTLQn
qxxm5otPwnZ8/0cv4iNw5V5x9p91WbnruphSP69x4KK68wYHOh9qKU/7ixa0xzGu
CMjo2kIwYNgvKT7IX1YYLTNZwB5r91H9P9Q2nYu0s8O9gE3JTeys7KiZDthc7S3F
ZQkIpH7vIMKMoC6YG/ZLwkk9fkQs+Pa2EqsslZ/DBdGSMSC3r6HjnMof3V5LSPoZ
q5AWMkIiEjysWmPMaqZAOoKGW423hcYr9wR/fJWgZc2bjN3U3udNSA4n45vvpqxV
/1llphi8Ry8ytBE6y7nbpQ/56lE1ytknxaD1I72b4qi5H+A+KNz1t4SFcqEROsTs
rqyKby04HQthpBAcUFnL
=KpqP
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jul_2013_13_14_27_+1000_RFhC13xyzAXUJlUt--
