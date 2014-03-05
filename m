Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbaCEOy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:54:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:44055 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758426AbaCEOyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:54:24 -0500
Date: Wed, 5 Mar 2014 15:54:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [patch 2/5] mips: Validate online cpus in irq_set_affinity()
 callbacks
In-Reply-To: <20140305112038.GW9987@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1403051554180.18573@ionos.tec.linutronix.de>
References: <20140304202425.102779779@linutronix.de> <20140304203100.744800502@linutronix.de> <20140305112038.GW9987@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Peter Zijlstra wrote:

> On Tue, Mar 04, 2014 at 08:43:39PM -0000, Thomas Gleixner wrote:
> > +	i = cpumask_first_and(mask< cpu_online_mask);
> > +	i = cpumask_first_and(mask< cpu_online_mask);
> 
> s/</,/ ?

Duh, yes. 
