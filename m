Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab3FGD2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 23:28:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37446 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab3FGD2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 23:28:37 -0400
Date: Thu, 6 Jun 2013 20:28:31 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.10-rc5
Message-ID: <20130607032818.GA18403@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit bb3ec6b08396bbd631b6441102dd1c3d89cbc576:

  mm: Fix virt_to_page() warning (2013-05-22 08:05:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git tags/ecryptfs-3.10-rc5-msync

for you to fetch changes up to bc5abcf7e411b889f73ea2a90439071a0f451011:

  eCryptfs: Check return of filemap_write_and_wait during fsync (2013-06-04 23:53:31 -0700)

----------------------------------------------------------------
* Fixes how eCryptfs handles msync to sync both the upper and lower file
* A couple of MAINTAINERS updates

----------------------------------------------------------------
Dustin Kirkland (1):
      Update eCryptFS maintainers

Paul Taysom (1):
      ecryptfs: fixed msync to flush data

Tyler Hicks (1):
      eCryptfs: Check return of filemap_write_and_wait during fsync

 MAINTAINERS        | 2 +-
 fs/ecryptfs/file.c | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJRsVNSAAoJENaSAD2qAscKFaIQAIYmS4one1LID1gUupPIvMs0
tPfFiIST4s84U0GirM8uZvIi1hRjRrRQWf9+3v+o/87YhcTsPInXBviWs78P6/ZL
eLUAkHiC4h3t7539ERFxwiOqs1cOeQEXQNMeq379cTAFomIZsh1991H9AySd8INM
gIrqg5vsh5OBdQG59h4sewiplCSDgWNj9TQTLhbTMP4/Iqa0CdRqV+TwLNBy1fiP
BM9/WfMD5H/Ez/7PNDKjVxPnROS7K6tQtb0Pv9wzhMiETu/Za4SckrZrs95SJv+A
3RvMQ6W8M7yUGQZm0uUg5CsL3dvhOvzQ3Cv9/+yQCr+pWCIKwvKSQ1j0eUG/hF0L
rhVGiVGwe1kNkhTdOTCYjeTMhK39ApJOi3CtWBT4YIbG/8sWl4J9leNl3ilxBKPF
0N0ONzDgRNDhgvqQHHt2oaohg/x3DjedNn3MflWw66FVmggVQvCtNFK02wQkRIg0
828gySs+QX8aODnRrZuECmgOVFkF+SlIZC9Vkn4XQ4+GMvaFiXK0j4rEeP+k9yR2
tIveGDTxqckvHYGqeib7zyiLIDSDYTiUvxzyWOwkPzr6TOAoHCsiJx/9QKaTi7ip
0D4bxv4wAzWzsmbuJu5F0/E2P3VH9COdGCk+xwGjYa6i19MIwAQL6BuKJddoSaaT
oU39FKvP7+61JI2zIsM3
=QHdb
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
