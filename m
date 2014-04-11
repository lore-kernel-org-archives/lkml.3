Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaDKJ7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:59:04 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:37138 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750848AbaDKJ7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:59:01 -0400
X-IronPort-AV: E=Sophos;i="4.97,841,1389715200"; 
   d="scan'208";a="29145720"
Message-ID: <5347BAA5.6070104@cn.fujitsu.com>
Date: Fri, 11 Apr 2014 17:49:25 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] f2fs: some fix and cleanup about flush_merge
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu Zheng (7):
  f2fs: put the bio when issue_flush completed
  f2fs: remove the unuseful "issue_tail" list
  f2fs: use __GFP_ZERO to avoid appending set-NULL
  f2fs: enable flush_merge only in f2fs is not read-only
  f2fs: add the flush_merge handle in the remount flow
  f2fs: introduce struct flush_cmd_control to wrap the flush_merge
    fields
  f2fs: introduce help function {create,destroy}_flush_cmd_control

 fs/f2fs/f2fs.h    |   17 ++++++---
 fs/f2fs/segment.c |  102 +++++++++++++++++++++++++++++++++++-----------------
 fs/f2fs/super.c   |   32 ++++++++++++++--
 3 files changed, 107 insertions(+), 44 deletions(-)

-- 
1.7.7


