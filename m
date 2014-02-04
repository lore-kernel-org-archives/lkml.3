Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbaBDUTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:19:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:49146 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbaBDUTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:19:12 -0500
Date: Tue, 4 Feb 2014 21:18:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: daniel.lezcano@linaro.org, peterz@infradead.org, fweisbec@gmail.com,
        agraf@suse.de, paul.gortmaker@windriver.com, paulus@samba.org,
        mingo@kernel.org, mikey@neuling.org, shangw@linux.vnet.ibm.com,
        rafael.j.wysocki@intel.com, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, anton@samba.org, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V2 2/2] tick/cpuidle: Initialize hrtimer mode of
 broadcast
In-Reply-To: <52F11ECE.605@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1402042118220.24986@ionos.tec.linutronix.de>
References: <20140124065501.17564.39363.stgit@preeti.in.ibm.com> <20140124065820.17564.83076.stgit@preeti> <alpine.DEB.2.02.1402041101330.24986@ionos.tec.linutronix.de> <52F11ECE.605@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, Preeti U Murthy wrote:
> Do you want me to send out the next version with the above corrections
> including the patch added to this thread where we handle archs setting
> the CPUIDLE_FLAG_TIMER_STOP flag?

Yes please.
