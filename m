Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab3KBMSV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 08:18:21 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:41447 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3KBMST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 08:18:19 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Noam Camus <noamc@ezchip.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] Critical ARC Fix for 3.12
Date: Sat, 2 Nov 2013 17:47:48 +0530
Message-ID: <1383394669-20175-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for this extemely late patch for 3.12 but it causes a SMP build of ARC
to panic in boot.

Greg, the patch as it is doesn't apply to 3.10 (but does to 3.11). So can you
please queue it up for 3.11 and I'll send a fixup for 3.10.

Thx,
-Vineet


Vineet Gupta (1):
  ARC: Incorrect mm reference used in vmalloc fault handler

 arch/arc/mm/fault.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
1.8.1.2

