Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3E1TyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:54:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026Ab3E1TyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:54:03 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Andi Kleen <andi@firstfloor.org>, Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] hugetlbfs: support split page table lock
Date: Tue, 28 May 2013 15:52:49 -0400
Message-Id: <1369770771-8447-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In previous discussion [1] on "extend hugepage migration" patches, Michal and
Kosaki-san commented that in the patch "migrate: add migrate_entry_wait_huge()"
we need to solve the issue in the arch-independent manner and had better care
USE_SPLIT_PTLOCK=y case. So this patch(es) does that.

I made sure that the patched kernel shows no regression in functional tests
of libhugetlbfs.

[1]: http://thread.gmane.org/gmane.linux.kernel.mm/96665/focus=96661

Thanks,
Naoya Horiguchi
