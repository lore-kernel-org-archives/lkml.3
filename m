Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab3IJEiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:38:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58814 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3IJEiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:38:15 -0400
Date: Tue, 10 Sep 2013 14:38:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Sep_2013_14_38_07_+1000_j9j.9Hnjj0hAW.9d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Sep_2013_14_38_07_+1000_j9j.9Hnjj0hAW.9d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/dcache.c
between commit 8aab6a27332b ("vfs: reorganize dput() memory accesses")
from Linus' tree and commit "dcache: convert to use new lru list
infrastructure" from the akpm tree.

/me mutters about development happening during the merge window -
especially when Andrew is absent.

I have no idea if this will be correct, but I just used the version from
the akpm tree (effectively reverting parts of commit 8aab6a27332b) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Sep_2013_14_38_07_+1000_j9j.9Hnjj0hAW.9d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSLqI0AAoJEECxmPOUX5FEJd8P/2wpq6PkuI4lcKBzAcCf7kRO
CBV6421MDTgpWbMV9xDbBWnrbTnx/jkYdN3SbC34rZEI6pPgYfJ9iUAzrTejB0Vq
jTchALkcyofEc9Qx3FRMqAcd8hYuUKrcak7V0jHnMH9FY0E5FWffO4q/2BX7DJJM
/SLHI36rl+XE3h+ZDZbl1PjokRL65q2nPUELhUmIfXO9s1bLfpKM73cU0o17d6TJ
rbCf7ZViQMB9XdacLSYjtpQgaD2zBhPgLfM8SrxBf0wJrHVmR5ZYONt7ctVvvgV4
8tzciRqRaEAJbZzlLxJ0hxcOOuttRORMkiPXtIgvX6GaJ4SNn/LVkiDb6xxkkpax
oufOI8H7wWCaarLnxEzwyGcpM3ICHVy4s2aK9uhUUNW16jnTRGzNLQC7bLN2pCk3
oE3fc1tGrkOClxzAOiYQU49/likedPnoychkmOJVkqTpzeb3L8Olx1eG5nr1gMrF
CEZpPCyhPMcQanzifU5yGnOm4x9I0bwEbQ2DGXqj2sEFK/dXN1oloCr8EpxT23FQ
rnbVYZrct8SS9R3ueEwBuYdzXxr9EHIdUqHvfw9Z98DlAaV17VdKoF8sa2GZRRZi
/7BRdMlg7qglCprVGSazMk4ozBK5ehVPZODKvQiG1hds9iBBDjOAhwvhdGkTXLk2
XAW1dQXY5304vMSNoj/2
=Hdh+
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Sep_2013_14_38_07_+1000_j9j.9Hnjj0hAW.9d--
