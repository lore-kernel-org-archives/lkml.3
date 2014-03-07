Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaCGKwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:52:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:23066 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbaCGKwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:52:02 -0500
X-IronPort-AV: E=Sophos;i="4.97,607,1389715200"; 
   d="scan'208";a="9660332"
Message-ID: <5319A2C4.7040404@cn.fujitsu.com>
Date: Fri, 07 Mar 2014 18:43:16 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] f2fs: some minor fix and clean up
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:49:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:49:22,
	Serialize complete at 2014/03/07 18:49:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Gu Zheng (5):
  f2fs: update start nid once each circle
  f2fs: remove the unused ctor argument of f2fs_kmem_cache_create()
  f2fs: format segment_info's show for better legibility
  f2fs: optimize restore_node_summary slightly
  f2fs: add a wait queue to avoid unnecessary build_free_nid

 fs/f2fs/checkpoint.c |    4 +-
 fs/f2fs/f2fs.h       |    5 ++-
 fs/f2fs/gc.c         |    2 +-
 fs/f2fs/node.c       |   64 ++++++++++++++++++++++++++++----------------------
 fs/f2fs/recovery.c   |    2 +-
 fs/f2fs/segment.c    |    9 ++++--
 fs/f2fs/super.c      |    9 ++++---
 7 files changed, 54 insertions(+), 41 deletions(-)

-- 
1.7.7

