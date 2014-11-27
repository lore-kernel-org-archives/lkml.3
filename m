Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaK0IHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:07:10 -0500
Received: from mdfmta005.mxout.tbr.inty.net ([91.221.168.46]:59642 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751280AbaK0IHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:07:07 -0500
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: texstar@gmail.com, martin@mvath.de, guanx.bac@gmail.com, bruno@wolff.to,
        dave@vasilevsky.ca, szycha@gmail.com, blyons@students.naropa.edu,
        tokiclover@gmail.com, afm404@gmail.com, hugochevrain@gmail.com,
        Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 0/2] Squashfs: add LZ4 compression
Date: Thu, 27 Nov 2014 08:00:47 +0000
Message-Id: <1417075250-6502-1-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
X-MDF-HostID: 8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following is a repost of the Squashfs LZ4 compression patches
updated to the latest -rc kernel.  These patches were originally sent
last year, but they did not receive much interest at the time.

These patches are being reposted by popular demand.  I have received
many private and public requests to repost these patches and to get
them mainlined.

My intention is to submit them in the next kernel merge window.
If you want LZ4 support in Squashfs now is a good time to publically
support the inclusion of these patches.

Phillip Lougher (2):
      Squashfs: add LZ4 compression support
      Squashfs: Add LZ4 compression configuration option

 Documentation/filesystems/squashfs.txt |    8 +-
 fs/squashfs/Kconfig                    |   15 ++++
 fs/squashfs/Makefile                   |    1 +
 fs/squashfs/decompressor.c             |    7 ++
 fs/squashfs/decompressor.h             |    4 +
 fs/squashfs/lz4_wrapper.c              |  142 ++++++++++++++++++++++++++++++++
 fs/squashfs/squashfs_fs.h              |    1 +
 7 files changed, 174 insertions(+), 4 deletions(-)
 create mode 100644 fs/squashfs/lz4_wrapper.c

These patches are also available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-lz4.git master

Squashfs-tools 4.3 already supports LZ4 compression.

Phillip
