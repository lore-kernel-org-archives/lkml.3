Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaHNR1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:27:55 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:21630 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaHNR1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:27:53 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 0/2] rwlock, x86: remove unused rwlock code
Date: Thu, 14 Aug 2014 13:27:29 -0400
Message-Id: <1408037251-45918-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the queued rwlock has replaced the original rwlock code for the
x86 architecture, this patch set removes those unused code to make
the header files look cleaner and less confusing.

Waiman Long (2):
  rwlock, x86: clean up asm/spinlock*.h to remove old rwlock code
  rwlock, x86: delete unused asm/rwlock.h and rwlock.S

 arch/x86/include/asm/rwlock.h         |   49 --------------------
 arch/x86/include/asm/spinlock.h       |   81 +--------------------------------
 arch/x86/include/asm/spinlock_types.h |    4 --
 arch/x86/lib/Makefile                 |    1 -
 arch/x86/lib/rwlock.S                 |   44 ------------------
 5 files changed, 2 insertions(+), 177 deletions(-)
 delete mode 100644 arch/x86/include/asm/rwlock.h
 delete mode 100644 arch/x86/lib/rwlock.S

