Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaBIWsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:48:53 -0500
Received: from smtprelay0010.hostedemail.com ([216.40.44.10]:43124 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751691AbaBIWsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:48:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:960:968:988:989:1260:1345:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3866:3867:3868:4250:4605:5007:6261:10004:10026:10848:11658:11914:12043:12291:12296:12517:12519:12679:12683:13311:13357:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: smash19_1305f28ae700c
X-Filterd-Recvd-Size: 1521
From: Joe Perches <joe@perches.com>
To: Petr Vandrovec <petr@vandrovec.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] ncpfs: Logging cleanups
Date: Sun,  9 Feb 2014 14:48:44 -0800
Message-Id: <cover.1391985629.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly style updating with a couple of fmt/arg mismatch fixes

Joe Perches (5):
  ncpfs: Add pr_fmt and convert printks to pr_<level>
  ncpfs: Convert DPRINTK/DDPRINTK to ncp_dbg
  ncpfs: Convert PPRINTK to ncp_vdbg
  ncpfs: Remove now unused PRINTK macro
  ncpfs: inode: Fix mismatch printk formats and arguments

 fs/ncpfs/dir.c           | 65 ++++++++++++++++++++++--------------------------
 fs/ncpfs/file.c          | 24 ++++++++++--------
 fs/ncpfs/getopt.c        | 12 +++++----
 fs/ncpfs/inode.c         | 32 ++++++++++++------------
 fs/ncpfs/ioctl.c         | 17 ++++++-------
 fs/ncpfs/mmap.c          |  2 +-
 fs/ncpfs/ncp_fs.h        | 30 +++++++++++-----------
 fs/ncpfs/ncplib_kernel.c | 28 ++++++++++-----------
 fs/ncpfs/sock.c          | 49 ++++++++++++++++++------------------
 fs/ncpfs/symlink.c       |  2 +-
 10 files changed, 130 insertions(+), 131 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

