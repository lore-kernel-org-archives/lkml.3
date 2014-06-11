Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaFKSoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:44:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:34267 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaFKSoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:06 -0400
Message-Id: <20140611182944.108526809@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 18:44:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch V4 00/10] rtmutex: Code clarification and optimization
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully the last iteration of this.

I addressed all the review comments and added the following new ones:

1/n: plug unlock race.
   
	Patch was separately posted already in the safety of
   	*mutex_unlock() thread.

2/n: Document and simplify the trylock path

3/n: Document and simplify try_to_take_rtmutex()

Thanks,

	tglx



