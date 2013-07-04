Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab3GDLAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:00:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:40434 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3GDLAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:00:50 -0400
Date: Thu, 4 Jul 2013 13:00:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Shi <alex.shi@intel.com>
cc: hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
In-Reply-To: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
Message-ID: <alpine.DEB.2.02.1307041300020.11637@ionos.tec.linutronix.de>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jul 2013, Alex Shi wrote:

> We find some benchmarks drop a lot on tip/sched/core on many Intel boxes,
> like oltp, tbench, hackbench etc. and bisected the commit 5d33b883ae
> cause this regression. Due to this commit, the clocksource was changed
> to hpet from tsc even tsc will be set CLOCK_SOURCE_VALID_FOR_HRES later
> in clocksource_watchdog. 

5d33b883ae is not in tip/sched/core. So what are you testing and
bisecting?
 
Thanks,

	tglx
