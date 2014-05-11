Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbaEKS3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 14:29:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:43804 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaEKS3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 14:29:23 -0400
Date: Sun, 11 May 2014 20:29:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <mgalbraith@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] CPU hotplug: Slow down hotplug operations
In-Reply-To: <20140511170234.GA2681@xo-6d-61-c0.localdomain>
Message-ID: <alpine.DEB.2.02.1405112026580.6261@ionos.tec.linutronix.de>
References: <1399492661-891-1-git-send-email-bp@alien8.de> <20140507130655.9f7c46de8cb39726079458fb@linux-foundation.org> <alpine.DEB.2.02.1405072214420.6261@ionos.tec.linutronix.de> <20140507202655.GI16722@pd.tnic>
 <20140511170234.GA2681@xo-6d-61-c0.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2014, Pavel Machek wrote:
> Well. If you add the delay, you'll mask real problems and cause regressions when
> the delay is removed -- because fix-hotplug will probably take time to get right.
> 
> Bad idea, AFAICT.

Agreed, but Boris is right, that the current duct tape hackery needs
to stop. And the delay was the desperate attempt to wake up people to
focus on replacing the current mess instead of making it more
entangled.

Thanks,

	tglx
