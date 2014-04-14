Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbaDNX5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:57:30 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:60205 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbaDNX52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:57:28 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, davidlohr@hp.com,
        aswin@hp.com
Subject: [PATCH 0/3] mm: vmacache updates
Date: Mon, 14 Apr 2014 16:57:18 -0700
Message-Id: <1397519841-24847-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two additions really. The first patch adds some needed debugging info.
The second one includes an optimization suggested by Oleg. I preferred
waiting until 3.15 for these, giving the code a chance to settle a bit.

Thanks!

Davidlohr Bueso (3):
  mm: fix CONFIG_DEBUG_VM_RB description
  mm,vmacache: add debug data
  mm,vmacache: optimize overflow system-wide flushing

 include/linux/vm_event_item.h |  4 ++++
 include/linux/vmstat.h        |  6 ++++++
 lib/Kconfig.debug             | 13 +++++++++++--
 mm/vmacache.c                 | 19 ++++++++++++++++++-
 mm/vmstat.c                   |  4 ++++
 5 files changed, 43 insertions(+), 3 deletions(-)

-- 
1.8.1.4

