Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3EUMqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 08:46:10 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:42574 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3EUMqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 08:46:09 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] ARC MM Bug Fix
Date: Tue, 21 May 2013 18:14:18 +0530
Message-ID: <1369140259-30501-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.228]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have a ARC MM bug fix, and it seems the best way to CC stable explicitly, is
to send a patch to them (and hence you as well - as opposed to regular
pull-req). OK with you ?

Please merge.

Thx,
-Vineet

Vineet Gupta (1):
  ARC: [mm] copy_(to|from)_user() to honor usermode-access permissions

 arch/arc/include/asm/pgtable.h |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

-- 
1.7.10.4

