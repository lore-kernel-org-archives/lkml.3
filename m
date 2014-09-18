Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbaIRJEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:04:41 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:38847 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbaIRJEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:04:39 -0400
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: tom.leiming@gmail.com, axboe@kernel.dk
Cc: kvm@vger.kernel.org, stable@vger.kernel.org, borntraeger@de.ibm.com,
        rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        mst@redhat.com, dahi@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH] blk-mq: Avoid race condition with uninitialized requests
Date: Thu, 18 Sep 2014 11:04:30 +0200
Message-Id: <1411031071-40390-1-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091809-5024-0000-0000-00000157BD2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should fix the bug reported in https://lkml.org/lkml/2014/9/11/249.

Test is still pending.

David Hildenbrand (1):
  blk-mq: Avoid race condition with uninitialized requests

 block/blk-mq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
1.8.5.5

