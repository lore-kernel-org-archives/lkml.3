Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaIZUnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:43:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbaIZUno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:43:44 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH 0/2] hugetlb minor improvements
Date: Fri, 26 Sep 2014 16:42:05 -0400
Message-Id: <1411764127-31641-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does minor improvements and cleanups for mm/hugetlb.c.
It's based on mmotm-2014-09-25-16-28 and shows no regression in libhugetlbfs test.

Tree: git@github.com:Naoya-Horiguchi/linux.git
Branch: mmotm-2014-09-25-16-28/hugetlb_minor_improvements
---
Summary:

Naoya Horiguchi (2):
      mm/hugetlb: improve suboptimal migration/hwpoisoned entry check
      mm/hugetlb: cleanup and rename is_hugetlb_entry_(migration|hwpoisoned)()

 mm/hugetlb.c | 60 ++++++++++++++++++++++--------------------------------------
 1 file changed, 22 insertions(+), 38 deletions(-)
