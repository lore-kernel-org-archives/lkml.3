Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3KSKJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:09:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27597 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab3KSKJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:09:28 -0500
X-IronPort-AV: E=Sophos;i="4.93,728,1378828800"; 
   d="scan'208";a="9074455"
Message-ID: <528B375A.9050309@cn.fujitsu.com>
Date: Tue, 19 Nov 2013 18:03:06 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5]  f2fs: some minor cleanups and logic fixes
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 18:07:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 18:07:32,
	Serialize complete at 2013/11/19 18:07:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Gu Zheng (5):
  f2fs: convert remove_inode_page to void
  f2fs: convert dev_valid_block_count to void
  f2fs: convert inc/dec_valid_node_count to inc/dec one count
  f2fs: simplify write_orphan_inodes for better readable
  f2fs: move the list_head initialization into the lock protection
    region

 fs/f2fs/checkpoint.c |   53 ++++++++++++++++++++++++++-----------------------
 fs/f2fs/f2fs.h       |   37 ++++++++++++++++------------------
 fs/f2fs/node.c       |   18 ++++++----------
 3 files changed, 52 insertions(+), 56 deletions(-)

-- 
1.7.7

