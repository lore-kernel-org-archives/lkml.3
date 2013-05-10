Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab3EJDMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 23:12:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36016 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3EJDL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 23:11:58 -0400
Date: Fri, 10 May 2013 13:11:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kent Overstreet <koverstreet@google.com>
Subject: linux-next: build warning after merge of the akpmtree
Message-Id: <20130510131146.9646757173476e28de57f6aa@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_May_2013_13_11_46_+1000_B6LBC6Urnkiv1vog"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_May_2013_13_11_46_+1000_B6LBC6Urnkiv1vog
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

drivers/block/nvme-core.c: In function 'nvme_bio_split':
/scratch/sfr/next/drivers/block/nvme-core.c:483:19: warning: assignment fro=
m incompatible pointer type [enabled by default]
/scratch/sfr/next/drivers/block/nvme-core.c:484:19: warning: assignment fro=
m incompatible pointer type [enabled by default]

Introduced by commit 427e97080196 ("NVMe: Split non-mergeable bio
requests") from Linus' tree interacting with commit 6a4d55146334 ("block:
prep work for batch completion") from the akpm tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__10_May_2013_13_11_46_+1000_B6LBC6Urnkiv1vog
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRjGVyAAoJEECxmPOUX5FEkiUQAJ3gintTw97iHVcRia1bewZT
qJDBqwwoaO4nHhmXACdFQayrFWTnrRgP8HqtUaoG4sBWY9RY02dYM7XxL52cdxMS
muINIErMCOX+SaT9gSo55TJ2A7r5I+ptk66+k2giX1J+PXn6jLiI1lsiQ0yxKf3h
9A4vYRzMtyr5aOA4s0vu9souE2XP7IbHLg/cSpAXzGOyp03Ep8Xpbagll2aPvl/l
rZxroLYc5FCB0NoVDwV1EmcsysqfK+ArQd58DUT+qAM+iJSK3dqhbQ+g87GAtLIc
MIyK6U/IYaShp1LWGrqmYtKD42nnbBipRtteYN8Y4Qn5oohnMwdZBiPGH41ILtnW
5UZc5IAERHwV/w2/la+r0BTNS7x2/3Q9+Xr6MkVE8rsZ8TNn+fr+O5b48cT8/4yh
skmtnUY3/noF3hz5Cg9No5rFFRcv0j+BmDirdE4tFLNTEHeAfdN9LmfNy1p/tCf/
JIJp3HHX1uI3QDlEkLMjDwP6mFBs8iX4qgtGg7ZDATTortzQ11JzPK31Z2JTOcSl
or7eICYCfWzPEnMVdGZPflxb6vus6tDAphaR6z1tbWSsV0xIQk5Tr2P7LkUt5FnZ
FQYGdI/+LCYxsnENCq80f+PuwKq4XLBoQV8hiyDyMx+SuDKP75+WyckUecx1ue0R
Ss5/DJzpZGIgFw8QDDO0
=zoN3
-----END PGP SIGNATURE-----

--Signature=_Fri__10_May_2013_13_11_46_+1000_B6LBC6Urnkiv1vog--
