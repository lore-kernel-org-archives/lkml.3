Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaLNVzL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 16:55:11 -0500
Received: from mdfmta009.mxout.tbr.inty.net ([91.221.168.50]:59751 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750704AbaLNVzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 16:55:07 -0500
Message-ID: <548E0723.1070505@lougher.demon.co.uk>
Date: Sun, 14 Dec 2014 21:54:43 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Squashfs updates for 3.19
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MDF-HostID: 4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Squashfs updates...

Thanks

Phillip


The following changes since commit 5d01410fe4d92081f349b013a2e7a95429e4f2c9:

   Linux 3.18-rc6 (2014-11-23 15:25:20 -0800)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git tags/squashfs-updates

for you to fetch changes up to 62421645bb702c077ee5a462815525106cb53bcf:

   Squashfs: Add LZ4 compression configuration option (2014-11-27 18:48:44 +0000)

----------------------------------------------------------------
These patches optionally add LZ4 compression support to Squashfs.
LZ4 is a lightweight compression algorithm which can be used
on embedded systems to reduce CPU and memory overhead (in comparison
to the standard zlib compression).

These patches add the wrapper code to allow Squashfs to use
the existing LZ4 decompression code, and the necessary configuration
option.

----------------------------------------------------------------
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
