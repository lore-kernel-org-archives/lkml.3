Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab3FEVti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:49:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab3FEVfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 084/127] powerpc/tm: Update cause codes documentation
Date: Wed,  5 Jun 2013 14:34:11 -0700
Message-Id: <20130605213227.472380618@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 24b92375dc4ec8a15262e8aaaab60b7404d4b1e7 upstream.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/powerpc/transactional_memory.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/powerpc/transactional_memory.txt
+++ b/Documentation/powerpc/transactional_memory.txt
@@ -155,6 +155,7 @@ These are defined in <asm/reg.h>, and di
 kernel aborted a transaction:
 
  TM_CAUSE_RESCHED       Thread was rescheduled.
+ TM_CAUSE_TLBI          Software TLB invalide.
  TM_CAUSE_FAC_UNAV      FP/VEC/VSX unavailable trap.
  TM_CAUSE_SYSCALL       Currently unused; future syscalls that must abort
                         transactions for consistency will use this.


