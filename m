Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaJPNJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:09:57 -0400
Received: from ppsw-40.csi.cam.ac.uk ([131.111.8.140]:53401 "EHLO
	ppsw-40.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaJPNJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:09:56 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Thu, 16 Oct 2014 14:09:54 +0100 (BST)
From: Anton Altaparmakov <anton@tuxera.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net
Subject: [git pull] Small NTFS update
Message-ID: <Pine.LNX.4.64.1410161347570.15284@hermes-1.csi.cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is a small NTFS update notably implementing FIBMAP ioctl for NTFS by 
adding the bmap address space operation.  People seem to still want 
FIBMAP.

Please pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs.git master

to get these changes:

 Documentation/filesystems/ntfs.txt | 268 
-------------------------------------
 fs/ntfs/Makefile                   |   2 +-
 fs/ntfs/aops.c                     | 163 ++++++++++++++++++++--
 fs/ntfs/inode.c                    |  19 +--
 fs/ntfs/ntfs.h                     |   8 +-
 5 files changed, 167 insertions(+), 293 deletions(-)

Shortlog:

Anton Altaparmakov (4):
      NTFS: Split ntfs_aops into ntfs_normal_aops and ntfs_compressed_aop
            in preparation for them diverging.
      NTFS: Remove changelog from Documentation/filesystems/ntfs.txt.
      NTFS: Add bmap address space operation needed for FIBMAP ioctl.
      NTFS: Bump version to 2.1.31.

Thanks a lot in advance!

Best regards,

	Anton
-- 
Anton Altaparmakov <anton at tuxera.com> (replace at with @)
Senior Kernel Engineer, Tuxera Inc., http://www.tuxera.com/
Linux NTFS maintainer
