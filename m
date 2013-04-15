Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3DOJoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 05:44:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab3DOJoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 05:44:02 -0400
X-IronPort-AV: E=Sophos;i="4.87,475,1363104000"; 
   d="scan'208";a="7057088"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, yinghai@kernel.org, akpm@linux-foundation.org,
        wency@cn.fujitsu.com, mgorman@suse.de, tj@kernel.org,
        liwanp@linux.vnet.ibm.com
Cc: tangchen@cn.fujitsu.com, linux-mm@kvack.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Little error fix and cleanup.
Date: Mon, 15 Apr 2013 17:46:44 +0800
Message-Id: <1366019207-27818-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 17:42:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 17:42:34,
	Serialize complete at 2013/04/15 17:42:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set did the following things:

patch1: Remove unused parameter "nr_pages" of pages_correctly_reserved().
patch2: Use CONFIG_MEMORY_HOTREMOVE to protect kernel_physical_mapping_remove().
patch3: Add comments for parameter "nid" for memblock_insert_region().

Tang Chen (3):
  mm: Remove unused parameter of pages_correctly_reserved().
  mem-hotplug: Put kernel_physical_mapping_remove() declaration in
    CONFIG_MEMORY_HOTREMOVE.
  memblock: Fix missing comment of memblock_insert_region().

 arch/x86/mm/init_64.c |    2 +-
 drivers/base/memory.c |    5 ++---
 mm/memblock.c         |    9 +++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

