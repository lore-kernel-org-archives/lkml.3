Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaIPKLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:11:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbaIPKLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:11:44 -0400
Message-ID: <1410862294.6398.3.camel@menhir>
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Date: Tue, 16 Sep 2014 11:11:34 +0100
Organization: Red Hat UK Ltd
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Z3ocbH5dokD6kcQA/Dpb"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Z3ocbH5dokD6kcQA/Dpb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following fixes for GFS2,

Steve.

---------------------------------------------------------------------------=
-----
The following changes since commit 372b1dbdd1fb5697890b937228d93cfd9c734c90=
:

  Merge branch 'for-linus' of git://git.samba.org/sfrench/cifs-2.6 (2014-08=
-20 18:33:21 -0500)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ta=
gs/gfs2-fixes

for you to fetch changes up to cfb2f9d5c921e38b0f12bb26fed10b877664444d:

  GFS2: fix d_splice_alias() misuses (2014-09-12 20:58:55 +0100)

----------------------------------------------------------------
Here are a number of small fixes for GFS2. There is a fix for FIEMAP
on large sparse files, a negative dentry hashing fix, a fix for
flock, and a bug fix relating to d_splice_alias usage. There are
also (patches 1 and 5) a couple of updates which are less
critical, but small and low risk.

----------------------------------------------------------------
Al Viro (1):
      GFS2: fix d_splice_alias() misuses

Benjamin Coddington (1):
      GFS2: Hash the negative dentry during inode lookup

Bob Peterson (2):
      GFS2: Change maxlen variables to size_t
      GFS2: Request demote when a "try" flock fails

Fabian Frederick (1):
      GFS2: fs/gfs2/super.c: replace seq_printf by seq_puts

Jan Kara (1):
      GFS2: Don't use MAXQUOTAS value

 fs/gfs2/bmap.c   |  9 +++++----
 fs/gfs2/file.c   | 15 ++++++++++++---
 fs/gfs2/incore.h |  7 +++++--
 fs/gfs2/inode.c  |  9 ++++++---
 fs/gfs2/super.c  | 20 ++++++++++----------
 5 files changed, 38 insertions(+), 22 deletions(-)


--=-Z3ocbH5dokD6kcQA/Dpb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUGAzbAAoJEMrg3m4a/8jSq68P/3+GMqeMNEkaDQv4nBPJzqzO
WJ2jQe8pnWiPdAJlcthc+tSsPFWv2GZOLGoG1Mtbh8+/bDN47BrV7eHFzXsoHHbc
6v8mr9G3boOM2vQcXURyxFlq1pKnyxw5NCHTBv117YfDM92RcFVIYiECLIHXKnia
z31P2g1Pb9/5ro7WBSYhvd+RXGyFL3IT24sI02PuW4vqXwuUF6NLaYjnBMgktpZ5
ACHGCKEjF5m4qyLzIpjgWH/HO0SFVoan5gLw++Mcp31xgCduSo9cYja8S1VkRs0E
dD/woG1ICsd/mIrjJKEaOMwxINp+9nGnrlTyTtkA6+D2PMG6zlb9F5F/MapbuVye
dld4ZGzWdkwuij3u4dwG7A/e1nM9neh+JoLRLLyyZw7+lWJxf6H0gh3yC/C85V4Q
QUYFzWkPw13HADf1ml7nO/s8GjLX4fyr/GTb6v9EoO9RFtwJ/oxThvHxh++Jye4/
KB97W5GHKXbcPdeiPx6xSbVC8qjRlak8eyZ7fw4O1PVl1qgptp3ldJe6rI4Dfd1d
VilqpK8O+Zm9/pncBKw0ueXEBnJIMH/sPfyaJpcVeMTKGPzJu6p8EauNC4rHFXFp
ndAGs9LtYxerYiiLaLXchJ/5npbCU6Xxq/314xNkp78o8Dl2zFA/KBxM08dohE83
/nKg1owZZHPLQ23cW3Ar
=OqJz
-----END PGP SIGNATURE-----

--=-Z3ocbH5dokD6kcQA/Dpb--

