Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaKLWdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:33:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbaKLWdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:33:44 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        andi@firstfloor.org, rientjes@google.com, riel@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org, davidlohr@hp.com
Subject: [PATCH 0/3] hugetlb: misc small fixes/improvements
Date: Wed, 12 Nov 2014 17:33:10 -0500
Message-Id: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series contains three independent patches for hugetlb. The first one
is a doc fix, the second and third ones are little code improvements.

Please, check individual patches for details.

Luiz Capitulino (3):
  hugetlb: fix hugepages= entry in kernel-parameters.txt
  hugetlb: alloc_bootmem_huge_page(): use IS_ALIGNED()
  hugetlb: hugetlb_register_all_nodes(): add __init marker

 Documentation/kernel-parameters.txt | 4 +---
 mm/hugetlb.c                        | 4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

-- 
1.9.3
