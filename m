Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3BVKYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:24:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:56650 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab3BVKYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:24:05 -0500
Date: Fri, 22 Feb 2013 11:24:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
cc: Jason Liu <liu.h.jason@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
In-Reply-To: <5127436E.4040100@ti.com>
Message-ID: <alpine.LFD.2.02.1302221122290.22263@ionos>
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com> <alpine.LFD.2.02.1302201400400.22263@ionos> <CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com> <alpine.LFD.2.02.1302211015270.22263@ionos>
 <CAB4PhKf+Z-TK4KGDZm1kYOWibg=e2Ehnhjxt_oTbFq9eqouAjA@mail.gmail.com> <alpine.LFD.2.02.1302211436300.22263@ionos> <51263975.20906@ti.com> <alpine.LFD.2.02.1302212214020.22263@ionos> <5127436E.4040100@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Santosh Shilimkar wrote:
> BTW, Lorenzo off-list mentioned to me about warning in boot-up
> which I missed while testing your patch. It will take bit more
> time for me to look into it and hence thought of reporting it.
> 
> [    2.186126] ------------[ cut here ]------------
> [    2.190979] WARNING: at kernel/time/tick-broadcast.c:501
> tick_broadcast_oneshot_control+0x1c0/0x21c()

Which one is that? tick_broadcast_pending or tick_force_broadcast_mask ?

