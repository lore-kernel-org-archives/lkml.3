Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab3LFS0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:26:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:60047 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab3LFS0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:26:36 -0500
Date: Fri, 6 Dec 2013 19:26:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <davidlohr@hp.com>
cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Subject: Re: [PATCH v2 4/4] futex: Avoid taking hb lock if nothing to
 wakeup
In-Reply-To: <1386063927-6545-5-git-send-email-davidlohr@hp.com>
Message-ID: <alpine.DEB.2.02.1312061924390.30673@ionos.tec.linutronix.de>
References: <1386063927-6545-1-git-send-email-davidlohr@hp.com> <1386063927-6545-5-git-send-email-davidlohr@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Davidlohr Bueso wrote:
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> Signed-off-by: Jason Low <jason.low2@hp.com>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

Who is the author of this? According to the SOB chains its Waiman, who
handed it down to Jason and it finally got sumbitted by you. Is that
correct?

Thanks,

	tglx
