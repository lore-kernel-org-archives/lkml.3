Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaA2AyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 19:54:18 -0500
Received: from ozlabs.org ([203.10.76.45]:48239 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867AbaA2AyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 19:54:16 -0500
Date: Wed, 29 Jan 2014 11:54:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the btrfs tree with Linus' tree
Message-Id: <20140129115403.4d2772c096a4fc7a4c9cb156@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Jan_2014_11_54_03_+1100_Zy6tTNpn.ESQF_Bm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Jan_2014_11_54_03_+1100_Zy6tTNpn.ESQF_Bm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the btrfs tree got a conflict in
fs/btrfs/acl.c between commit 996a710d4641 ("btrfs: use generic posix ACL
infrastructure") from the  tree and commit cfad95253440 ("btrfs: remove
dead code") from the btrfs tree.

I fixed it up (I used the version from Linus' tree) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__29_Jan_2014_11_54_03_+1100_Zy6tTNpn.ESQF_Bm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6FE2AAoJEMDTa8Ir7ZwV4p4P/0n+Jn9GqalJ9KFg3mnheIrv
1kW2aWEu+UUv4dkF9z4n4MvNI9kYY86nkTzKFT+VF/sARS0AfCiHF4M47R0ybB6Z
ZwkLG5SwMGTIu1hjAMQbOCYir28SElRs0FXx3Ib2V7yyj6dcT16kB3zGg+kDw8eX
//YAf0ev8jsRLZNoTMyyk1DQ9b8k2GrLt8cJ/0LXimvuZL1A+WcmT1vnpB4jo4tY
luYKPsYME9G7+mCwPT3BXMbHawhihRQg1/HecAPKgCS9qj4cgOtIClyvJIHUSIJa
aOrUB924OvsojRwrGkh5/ZUL+0zFT3aBgSQhpIWYVUALaNoGkzyQZ1zfN75ZLFVy
mH8k3u+SsYKzsQJDg3rY7E5vkB8Xi7EupYLNjzIq0pbtxFQjjpLbUAJaf182c298
6A7Um3gvIxGP+LiKxQW6ASOZ9Mo+5TuHYhGdoOVZbptZJawFjjH0b/7jlRPMtM4N
spJZdgj5OE7kc9GKqBKnvpIWURrbRetE7xXqv0YxCggrAI8epp/n5XqP1O2y7JIu
HNkjKaNsc9FSaLzqWBaBtxDpTSpUqHz9VW60FIqOIayVUWB1H4t+TidRFSTPj+Vd
2SvxeJIUIS5tzAM13dUQzpIhn3jpNKLhB/rcjDIJW0epE/vo0Cpmh0zrZ+f4i1O/
ogRzmhTX7yqUYOxX02k8
=3X1c
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Jan_2014_11_54_03_+1100_Zy6tTNpn.ESQF_Bm--
