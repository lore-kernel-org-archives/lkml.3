Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab3HNBS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 21:18:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53893 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758288Ab3HNBS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 21:18:57 -0400
Date: Wed, 14 Aug 2013 11:18:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Linus <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>
Subject: linux-next: manual merge of the arm-current tree with Linus' tree
Message-Id: <20130814111837.9a692a77b35ba8cbb4a9149b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Aug_2013_11_18_37_+1000_huD=kGzHHCaJkfm5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Aug_2013_11_18_37_+1000_huD=kGzHHCaJkfm5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm-current tree got a conflict in
arch/arm/kernel/perf_event.c between commit b88a2595b6d8 ("perf/arm: Fix
armpmu_map_hw_event()") from Linus' tree and commit d9f966357b14 ("ARM:
7810/1: perf: Fix array out of bounds access in armpmu_map_hw_event()")
from the arm-current tree.

These are the same patch except for the return code (and the much more
comprehensive commit message in the arm-current tree version).  I fixed it =
up
(using the arm-current tree version - return -EINVAL instead of -ENOENT - I=
 have
no way to guess which is right) and can carry the fix as necessary (no
action is required).

P.S. the version in Linus' tree has no Signed-off-by from the author.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Aug_2013_11_18_37_+1000_huD=kGzHHCaJkfm5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCtr1AAoJEECxmPOUX5FEY8wP/RsHZGINzj4bSVGiUL/ao3OY
Rc0SZvHjms5WsWgQDOC/kk6Cvz9DFKYvTJrwKk1GMum32PfZqSJoQ3bSakYG9pXg
yLXx3oyn+Su20WHXbuDNAv6AkE7NdCYpy0yZs6PSBoa5PeoSxOTdvvd8HS4/KcXP
8DP1PdQuzye3hRIKY0zEnhXdX64YyH5l95hX6atbrL2hDpXCMDuP1utPKLsJLhEP
IKnCwOtv2R92a+dwoho7mH+1fSAlpjGGrixpxCdKBP/Fn9uWo5Q9sa8WqcF85NwU
Tr+odBZJOmInr6ZCJezPX9hpL/t/c8lmT7dk+3pcu1wBzah00NNC9HZUYIFK/OaF
5YDRTlq7IuFSeaOiqT61XCI5jiyAo5/ZTDbV8xhBfQEqqtEha5WJuzZxNhpqFsGY
wXz/I7Xv1U4UMx+BfwywuMaYaqOLia5SO4uPJkbN22oFEVy1AmuXr6Z9k8oQ+qm5
1kPYTrv3CXqNR76oVx85MyuIS0RjxhyVnY6yH0wIMZc/+mFtWCduZ03z/vdlJTTS
i4A4gsBttgwUBffe/L170okL9lOGje2w7hsk8XTOc0vPlatuCyQMAZDZUhAzMLbE
YPNak5lo7ew1Dbo6hDZRkFUWCRJSX35CaaLQxnd/r6Vzm8OMXChnBgD2V1tnTL8Z
8XzCL7jPRzEA7/gpKUjF
=B+uc
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Aug_2013_11_18_37_+1000_huD=kGzHHCaJkfm5--
