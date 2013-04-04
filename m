Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab3DDEem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 00:34:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45116 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab3DDEel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 00:34:41 -0400
Date: Thu, 4 Apr 2013 15:34:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the staging tree with the vfs tree
Message-Id: <20130404153433.be980c842e6b7a41afa0168f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_15_34_33_+1100_C1FtxSwIWNbTqPb7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_15_34_33_+1100_C1FtxSwIWNbTqPb7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got conflicts in
drivers/staging/dgrp/dgrp_dpa_ops.c, drivers/staging/dgrp/dgrp_mon_ops.c,
drivers/staging/dgrp/dgrp_net_ops.c and
drivers/staging/dgrp/dgrp_ports_ops.c between commit 33633903f16f ("dgrp
procfs fixes, part 5: per-node files") from the vfs tree and commit
433121c6ef51 ("staging: dgrp: cleanup sparse warnings") from the staging
tree.

The former removed the code modified by the latter, so I just did that
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Apr_2013_15_34_33_+1100_C1FtxSwIWNbTqPb7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXQLZAAoJEECxmPOUX5FEhjUP/2l9QJVBf/zkgdq/EtSyzgBN
EAoxwbGhwLLUCrd6tdSSv6eq+f+mxuo5njnkNxF4b3lp7FgjknKPlibWxb0wRfDP
pXeqwGm4eidWNY1/rt4E0gnzFxTj6b4ZuhiF3rDXDjg8nBaH0bWFpnRUso2h8Y9Q
ci9QVQN+Z4AXqelKviwO80SerUbBZ1mxSv2v29Q8Foau2SB5hLhhP72l3zHbzev7
WZxrpAJ/GHEIsoC+VIF++lj5D4nMmLR5vM1geYy1fU4jEWQR3scfv96qW2BdV2BR
QHwfQYsniSjSps+yT62JcJhsZhYskknXJR803++ABUqH7Y91Y6aY6EQqLPyTy+G9
ulD9tWhoDWA+TIW6ibN6qsB5oGEy9p5tX7tcXJaLuFIMrPyumlUTp/TSYCt3ZZNo
nkh1Uq/4VZjfWhS0DMQvRE8FVAhQBYrnKB7UBL/QBsV9UD0oo3FUwFfsMU4lBXAc
uW8v1H0NNLxniUcAaDm0w3/667wt4OOj4aYci2zgG16lIsaKWUW/r7nRKCXDEAtk
8HJn35c7JQG5/zeguRLODYwzDv/9CkxuGd6xuTGGm9L54DbaefN+svOW1rsZGZF8
E3RYzvX+mKespkind2r/P8lKL6J0N/1VFf/Uscq2adiWlZ4VvYQhA3ev8ozbSIOY
1staHK1QLFsq7B5MvPhm
=382n
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_15_34_33_+1100_C1FtxSwIWNbTqPb7--
