Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaDRIJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:09:13 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:46929 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaDRIJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:09:06 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Peter Zijlstra <peterz@infradead.org>, <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 0/2] Build breakages for 3.15-rc1
Date: Fri, 18 Apr 2014 13:38:33 +0530
Message-ID: <1397808515-8013-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

In 3.15, RCU header updates are not working with the stale barrier.h
leftovers, causing build breakage.

I see that there was a post on linux-arch to same effect but it never got
merged due to other reasons.

Linus can you please apply ARC patch, I'll let Richard speak for Hexagon !

Thx,
-Vineet

Vineet Gupta (2):
  ARC: Delete stale barrier.h
  Hexagon: Delete stale barrier.h

 arch/arc/include/asm/barrier.h     | 37 -------------------------------------
 arch/hexagon/include/asm/barrier.h | 37 -------------------------------------
 2 files changed, 74 deletions(-)
 delete mode 100644 arch/arc/include/asm/barrier.h
 delete mode 100644 arch/hexagon/include/asm/barrier.h

-- 
1.8.3.2

