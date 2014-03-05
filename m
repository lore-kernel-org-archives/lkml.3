Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbaCELUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:20:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48090 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaCELUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:20:47 -0500
Date: Wed, 5 Mar 2014 12:20:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [patch 2/5] mips: Validate online cpus in irq_set_affinity()
 callbacks
Message-ID: <20140305112038.GW9987@twins.programming.kicks-ass.net>
References: <20140304202425.102779779@linutronix.de>
 <20140304203100.744800502@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304203100.744800502@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 08:43:39PM -0000, Thomas Gleixner wrote:
> +	i = cpumask_first_and(mask< cpu_online_mask);
> +	i = cpumask_first_and(mask< cpu_online_mask);

s/</,/ ?
