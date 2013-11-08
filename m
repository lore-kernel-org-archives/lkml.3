Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3KHGBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 01:01:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38225 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3KHGBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 01:01:40 -0500
Date: Fri, 8 Nov 2013 17:01:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matias Bjorling <m@bjorling.me>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the target-updates tree with Linus'
 tree
Message-Id: <20131108170113.7e9a88ecc8c409815a2548fa@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_17_01_13_+1100_y+9bHSsXYWL=RtHY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_17_01_13_+1100_y+9bHSsXYWL=RtHY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

Today's linux-next merge of the target-updates tree got a conflict in
lib/percpu-refcount.c between commit 5e9dd373dea4 ("percpu_refcount:
export symbols") from Linus' tree and commit c9e8d128fe31
("percpu-refcount: Add EXPORT_SYMBOL to use percpu_ref from modules")
from the target-updates tree.

I fixed it up (the version from Linus' tree used EXPORT_SYMBOL_GPL, so I
used that) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Nov_2013_17_01_13_+1100_y+9bHSsXYWL=RtHY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfH4uAAoJEMDTa8Ir7ZwVImwP/0OtOQd+Z9SimD6cZUAES+kb
6C7uu451JVte2pRMG34OBitxyC5vFvx7nvlvN65W3WGvtIuk5lx9B0D90s0dqTCM
g3CTGNbDEUSJsWPs5ftuw7yknZPLrtJz8SgVSTDhVIpfBhH3wikm9Fydvo5T9r4e
COe1GeDEdBMk58Z9yAt8AnqNxc6KuTsXK2j/FeMvdisU6a5SC3787pUeF36J4DMt
8vTbY/jip5l7FymHYzObaD4ZQn31ZmlMtEgUhYKjGZTCMWS7KMG2wnhgfdyQmBDs
SgJkm6M6h0Nxf2cYHiv66ZrRA6pd71a1FsDkGEp9My2pjM5nTybEhSUa5zAAIOQ1
JH/9BV11S4KbCqXmCNo3Rhd2P45SG06FT3NQV5EEHx9nqYM2rbmRklg4kcqBfgUi
gUdpNgo70EJbrb97CGamyoHGOWuk6ZDV6P/qFPP3k9cY3ELA3CKBi4mYAVqgDq5z
DyjRU6nB6RlNiA9i2ZwogeK9G0pc7nwiFQMazrtAsGaTvc4HdxHomnP1zg3CTMob
1bcAYFddN0QIcXyVIi1p+p84zf2nqK0vZ65hZGIf3wYuTszXVKj+K+/+JCZDyrmz
KqcrKqknrLfsaxoQLfPGXPAJ8eBdmCwEeGRPOjFDeUNMQtfiVV8b8mrWHagMJvBl
9ipY8b0lOPiC+/wJfFGT
=IAwd
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_17_01_13_+1100_y+9bHSsXYWL=RtHY--
