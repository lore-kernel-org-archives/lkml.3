Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3BGGDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:03:30 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59957 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3BGGD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:03:28 -0500
Date: Thu, 7 Feb 2013 17:03:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: linux-next: manual merge of the akpm-current tree with the kvm tree
Message-Id: <20130207170319.5b5c471398b134c676f9dc6c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Feb_2013_17_03_19_+1100_Q=fp.B81gENh+MHt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Feb_2013_17_03_19_+1100_Q=fp.B81gENh+MHt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/x86/kvm/mmu.c between commit 9bb4f6b15ec0 ("KVM: MMU: drop unneeded
checks") from the kvm tree and commit "hlist: drop the node parameter
from iterators" from the akpm-current tree.

I fixed it up (the conflicts were caused by bad white space changes in
the akpm tree patch) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__7_Feb_2013_17_03_19_+1100_Q=fp.B81gENh+MHt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRE0OnAAoJEECxmPOUX5FEUs0P/AuFBdd8wvBYHgAF46BbEkOd
YA/SsTIkUHbruwuXPmJbl11ELmTG73PDQ5TzBn/t6Erxct3sScq8rGNSzNWx8sPk
lhN5Hf86q3/IEFnRqdqg+SGe/Tq5CVG+bgRs6yIK2X6cfCOfZhbTsXXkBhij2XCm
2i8G9O6sEnIlhJUu+jG64iqX28J8aDcFKX8vYYERowvNEFUSmRfkcVcU24jcrg5Q
VVZu3gi3kotpSbcM3LgRE3bRtgRC1UUFPQ6BAWb7+Yqlh/mX/tFuIXtaGcw5kHk3
ZNBx3krUu3f6L3eQJ8N7mZ/lT5bq6ghyUumK6+JidiXr0ZRkr8WQxxbnCzDvXAIX
OMBrCafAyftI4sGS6rlS3cR1dpYSjvNJFYzRiinZkv9OStnzeMlo9bJr75kuTACU
0RD83M8yPMxk/wQqPGbdr5Rx+dh20fFxj4HFGDFN37GD1//UxLVQqhLZJxP0wcck
tIiQY+bNw2rm+BCV+J4hTJs0d5gwhJiQbygXRlA7ZouE8jQvLvd9Yl+P3LAiAucY
oDl4aLOx6QJHSTYnP0X6YzTtEpkPkbFD8UsO2YmoW8AzHDe/hpVjB0SMhKKESdNC
mWwFDSKy//Au9oJo35IWGea9EfBczQmXDZ5RVqQuaR1LaiVo6yLtRYfKeOQHrbgB
JGIc9SKPCi+BCpNWz/J1
=pVTi
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Feb_2013_17_03_19_+1100_Q=fp.B81gENh+MHt--
