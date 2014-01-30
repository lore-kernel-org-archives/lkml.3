Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaA3Nb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:31:57 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:46935 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaA3Nbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:31:55 -0500
Date: Thu, 30 Jan 2014 08:31:52 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 0/6] setting the table for integration of cpuidle with
 the scheduler
In-Reply-To: <20140130092835.GL11314@laptop.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.11.1401300830340.1652@knanqh.ubzr>
References: <1391017513-12995-1-git-send-email-nicolas.pitre@linaro.org> <20140130092835.GL11314@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Peter Zijlstra wrote:

> On Wed, Jan 29, 2014 at 12:45:07PM -0500, Nicolas Pitre wrote:
> > As everyone should know by now, we want to integrate the cpuidle
> > governor with the scheduler for a more efficient idling of CPUs.
> > In order to help the transition, this small patch series moves the
> > existing interaction with cpuidle from architecture code to generic
> > core code.  The ARM, PPC, SH and X86 architectures are concerned.
> > No functional change should have occurred yet.
> > 
> > @peterz: Are you willing to pick up those patches?
> 
> Yeah.. no objections. Should I pick these up or will you be sending
> another round?

I think you could pick them now, taking care of picking up the amended 
#1/6.


Nicolas
