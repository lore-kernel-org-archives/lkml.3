Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaEaP55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 11:57:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:34396 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaEaP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 11:57:53 -0400
Message-Id: <20140531155229.493650009@linutronix.de>
User-Agent: quilt/0.63-1
Date: Sat, 31 May 2014 15:57:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: [patch v2 0/5] rtmutex: Code clarification and optimization
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes vs. v1 [1]:

Dropped 1/N as it's queued already.

Removed the config symbols as pointed out by Steven.

Addressed the review feedback from Steven and Jason.

Thanks,

	tglx
---
[1] http://lkml.kernel.org/r/20140522031841.797415507@linutronix.de

