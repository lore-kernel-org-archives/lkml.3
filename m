Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab3CGBPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:15:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44467 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3CGBPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:15:31 -0500
Date: Wed, 6 Mar 2013 17:15:25 -0800
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.9-rc2
Message-ID: <20130307011512.GA31643@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit dfdebc24837ed0a1d6ad73b108a10d3c88d1b6e8:

  Merge tag 'for-linus-v3.8-rc4' of git://oss.sgi.com/xfs/xfs (2013-01-16 16:19:54 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git tags/ecryptfs-3.9-rc2-fixes

for you to fetch changes up to 290502bee239062499297916bb7d21d205e99d62:

  eCryptfs: allow userspace messaging to be disabled (2013-03-03 23:59:59 -0800)

----------------------------------------------------------------
Minor code cleanups and new Kconfig option to disable /dev/ecryptfs

The code cleanups fix up W=1 compiler warnings and some unnecessary checks. The
new Kconfig option, defaulting to N, allows the rarely used eCryptfs kernel to
userspace communication channel to be compiled out. This may be the first step
in it being eventually removed.

----------------------------------------------------------------
Dan Carpenter (1):
      eCryptfs: remove unneeded checks in virt_to_scatterlist()

Kees Cook (1):
      eCryptfs: allow userspace messaging to be disabled

Simon Que (1):
      eCryptfs: initialize payload_len in keystore.c

Tim Gardner (2):
      eCryptfs: decrypt_pki_encrypted_session_key(): remove kfree() redundant null check
      ecryptfs: ecryptfs_msg_ctx_alloc_to_free(): remove kfree() redundant null check

Tyler Hicks (3):
      eCryptfs: Fix -Wunused-but-set-variable warnings
      eCryptfs: Fix -Wmissing-prototypes warnings
      eCryptfs: Fix redundant error check on ecryptfs_find_daemon_by_euid()

 fs/ecryptfs/Kconfig           |  8 ++++++++
 fs/ecryptfs/Makefile          |  7 +++++--
 fs/ecryptfs/crypto.c          |  9 +++------
 fs/ecryptfs/dentry.c          |  2 --
 fs/ecryptfs/ecryptfs_kernel.h | 40 ++++++++++++++++++++++++++++++++++++++--
 fs/ecryptfs/file.c            |  2 --
 fs/ecryptfs/inode.c           |  8 ++++----
 fs/ecryptfs/keystore.c        |  9 ++++-----
 fs/ecryptfs/messaging.c       |  5 ++---
 include/linux/ecryptfs.h      | 12 ++----------
 10 files changed, 66 insertions(+), 36 deletions(-)

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJRN+ogAAoJENaSAD2qAscKKw8P/j6pruD+23xSPAaGWe2iSY74
HnXEknqtxFoOyY+9g4kmrjHxZh8wjOSGuZXV/HJyaFq+6bEIFYmXD/+NybTDDSeM
jZ9luTjF4QOeV+hj89SWv8fuEt/435ceTdxs7VD6TlkU6Hn9Cg52yJFL/fTvElOi
1N2jCWPIA2MhtH7JS3NxRELlcCHb14NXKSDKnVtXxBR3qW6KEnwS6XiNnxwMhtjY
b7TA1VTDZe4zOJcHIp11h3FM6KIbGHqXrkkH1QD9FxW22GyJik4sQa2IsOAQ6vgz
1IZVao/4qIqR4yhKXJE2BzSoYMtCwEDTLm5SPIegrMXqW0q+qqnXO18+LqsBd3hW
EYZzbLBJ2vi+I7w4oR3H1L6xhTAHzShduO1lyLxOXPeENU39xoNMXzL0s7A15oU0
LcvXtoLCBano6bNhbvFgXqC+i5tBYpByq7iYvYlCBjoOyFcsbLTgIZLyMu2KEvRM
7mDdLL74Rx5lYdZmboO8S9HHdkXEMuxP0C2+y12meuPQXJRnyjWbICGe42NLKPa7
et3qnqCPGO2O/Pfx3SSVH8/B6dEaY9Bq6ZUOTZMTd0+ovclll14Sr6ipWVqjI2wC
kwBI0ST3o5plv/HSrMa9WBpnytnO5PceTGLbSVHpl2ViHtbtEftXHbqZRIZF7BEm
6l+1M5gzUkoSLTUgk1YD
=sWpn
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
