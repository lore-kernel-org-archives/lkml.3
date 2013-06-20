Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248Ab3FTKHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:07:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40150 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab3FTKHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:07:23 -0400
X-IronPort-AV: E=Sophos;i="4.87,903,1363104000"; 
   d="scan'208";a="7614618"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: bcrl@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Fix some wrong comments.
Date: Thu, 20 Jun 2013 18:10:18 +0800
Message-Id: <1371723023-4060-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 18:06:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 18:06:16,
	Serialize complete at 2013/06/20 18:06:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some wrong comments found when reading code.

Tang Chen (5):
  page_isolation: Fix a comment typo in test_pages_isolated()
  page_migrate: Fix wrong comment in
    address_space_operations->migratepage()
  aio: Fix wrong comment in aio_complete()
  memblock: Fix wrong comment in __next_free_mem_range()
  bootmem, numa: Fix a comment typo in
    register_page_bootmem_info_node()

 fs/aio.c            |    2 +-
 include/linux/fs.h  |    4 ++--
 mm/memblock.c       |    2 +-
 mm/memory_hotplug.c |    4 ++--
 mm/page_isolation.c |    8 ++++----
 5 files changed, 10 insertions(+), 10 deletions(-)

