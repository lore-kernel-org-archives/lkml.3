Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966937Ab3E2PJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:09:12 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:64954 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966297Ab3E2PJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:09:10 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH, v2 0/5] clean stale VALID_PAGE() related code and comments
Date: Wed, 29 May 2013 23:08:51 +0800
Message-Id: <1369840136-1491-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a trivial patchset to remove stale VALID_PAGE() related code
and comments.

It applies on top of:
git://git.cmpxchg.org/linux-mmotm.git v3.10-rc2-mmotm-2013-05-22-16-40

Jiang Liu (5):
  mm/ALPHA: clean up unused VALID_PAGE()
  mm/ARM: fix stale comment about VALID_PAGE()
  mm/CRIS: clean up unused VALID_PAGE()
  mm/microblaze: clean up unused VALID_PAGE()
  mm/unicore32: fix stale comment about VALID_PAGE()

 arch/alpha/include/asm/mmzone.h     | 2 --
 arch/arm/include/asm/memory.h       | 6 ------
 arch/cris/include/asm/page.h        | 1 -
 arch/microblaze/include/asm/page.h  | 1 -
 arch/unicore32/include/asm/memory.h | 6 ------
 5 files changed, 16 deletions(-)

-- 
1.8.1.2

