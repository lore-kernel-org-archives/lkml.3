Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270Ab3DHHCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 03:02:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50200 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089Ab3DHHCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 03:02:46 -0400
Date: Mon, 8 Apr 2013 17:02:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: linux-next: manual merge of the akpm tree with the scsi tree
Message-Id: <20130408170231.3c50013bb8bacebab8ca4cea@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Apr_2013_17_02_31_+1000_2Rs1i1qywv8upa7/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Apr_2013_17_02_31_+1000_2Rs1i1qywv8upa7/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/scsi/qla2xxx/qla_attr.c between commit 4a9fa41bd404 ("[SCSI]
qla2xxx: Remove debug code that msleeps for random duration") from the
scsi tree and commit "scsi: rename random32() to prandom_u32()" from the
akpm tree.

The former removed the code in this file that was updated by the latter,
so I did that (and dropped the next patch ("scsi: fix the wrong position
of the comment") and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__8_Apr_2013_17_02_31_+1000_2Rs1i1qywv8upa7/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRYmuHAAoJEECxmPOUX5FEUwoP/0lQgdzAZp9ID4EePVRAOYn1
DqQcBeSZjpIgL6c3e9mGaPA6FB2OmrUTtjZu4BOM3IuoqTYD2oTCV5OocSHrCqbC
19UGjpwSFoMKg5ZJI0DPt2H9wdMCZaOoMghSwS+38ghuYKgGw5LFMOubKut6yzYm
YFM+0JHDnZ4IsglJc7hNmKZ0EB/k1OY6f4xCFPqUpoWvAcraPx86x+czs73Gx9Au
fzuV85Onb1UAgAq7vZGHTZQtkPUHaRINcK2Y9SpSDpw40axCzng1UakHDqvfMhwW
CQxDdeJd5zOaTTln2a/ix25VDUfqx+3sQT4Tz+edqtX10HfvmLDzKLzL71xBBiB7
oMzAdlVmy43Zy7xNuKmPmWeza3NSICaTMMnqKRDn0AxakOjdo5HF509LkiygTt0k
87WEQ4R0JJi46Fc9f2v9RC8ML2DenozKWFDXLoqvJawndZC9FUWf7UEVM8Cs3BYu
xzG0ZrqX7FNoZZqOlobZ6RiZE9+RflB7AzKtwQTt0QvMoTi8YkLe6xd7Mh68fHbo
z0xpPtBHe+Ih+RR7C9w+3gCNMUeNjOMhXj0fen9opt/vy0J01LeAz+3yjvNo0k/q
BdSsJ/MiqVwbC1+YLE/VT+bOU6pGNOTn8XMvoIn+Vo0XTzzvkPWAbwq1jWkE9HjB
AcEdbHTjEiZTZAF99S9z
=NI+5
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Apr_2013_17_02_31_+1000_2Rs1i1qywv8upa7/--
