Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3LCBw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 20:52:28 -0500
Received: from ozlabs.org ([203.10.76.45]:49765 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab3LCBwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 20:52:25 -0500
Date: Tue, 3 Dec 2013 12:52:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: linux-next: manual merge of the akpm-current tree with Linus' tree
Message-Id: <20131203125219.97839b4335adffdeb3ef7160@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Dec_2013_12_52_19_+1100_fVJUSE89EslNwWWx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Dec_2013_12_52_19_+1100_fVJUSE89EslNwWWx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/um/kernel/sysrq.c between commit 8ed12fcc194d ("um: Rename
print_stack_trace to do_stack_trace") from Linus' tree and commit
ce89e7878311 ("arch/um/kernel/sysrq.c: rename print_stack_trace()") from
the akpm-current tree.

I fixed it up (I used the version fro, Linus' tree) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__3_Dec_2013_12_52_19_+1100_fVJUSE89EslNwWWx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSnTlXAAoJEMDTa8Ir7ZwVP4UP/2pc4Ubq7r3Fc6zr+R/xKIys
N21Kn1CustYSJTAX8cyney4GKKmuobam+bAocKqfWh3VaQf3d6TS2HcQ6SGUF97A
jOT3lWaXv/Yap7CiAsYh8E+3Fq5t+xIj8hdeTX4jk10kzNBDGoLAVBa85ZkzAgqu
etqjQ0Rpczy9LCbgmLUUxkI4Pq8g7XYfCIdGlY0G37G+p4a3nE3kWPCG0265gWkW
TeP4vI/3cNkdoQ8Xo0nrTuxT0RJgmYz6wgNZeDfvxAU5v86Xqhyf3B91S4WyYyDA
WZLAkX9s/cE42J5bI0OeyvFpbQnevNNAgZY/YF3Pxy516511p2hULFP3fW26nED+
trvRf6SRmbPLbfTI2vORs6BAp1Lhp8XY9x0v9382zZQqjc7Vs3l8TMQYNxG9bTGj
064RhwR5Vs8eQvH891AXuWU8rp8H60+z/fo5L7vO77c6Z+5QzWv2aoxcO7OC9vJ3
L+9QjMGFFkPuIHaRwADwdg46fobyZ7ADUKBqmd7OvhtvlqW23Sl8X+G3vfoECjmB
q/qJHwGHsaMvMy2PYblwOYAj2N6I/VzCkRnngFPw8X7x1g/RVXuf0B+tbxV6Euo/
iQy5ak82whk3nf5kIFwFhat1n9V3tmlsr7HKrfOux0IxDpfV9i9YebDj0g3T8VcI
ZRjntTv9w+G9NljOsSD4
=Ozmo
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Dec_2013_12_52_19_+1100_fVJUSE89EslNwWWx--
