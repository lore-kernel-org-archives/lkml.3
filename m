Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3FENEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:04:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51573 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab3FENEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:04:12 -0400
Date: Wed, 5 Jun 2013 15:03:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>, mingo@redhat.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 1/2] sched: Optimize build_sched_domains() for saving
 first SD node for a cpu
Message-ID: <20130605130358.GL27176@twins.programming.kicks-ass.net>
References: <d226c91fed3dfa2dca644d14c88b1d1ff9d2e722.1370344689.git.viresh.kumar@linaro.org>
 <51AEC1C3.1040804@linux.vnet.ibm.com>
 <CAKohpokGrgFOtOT6Y3e4MOJBUQWT4FG4Mk-F6_M0V-pEEf3KYw@mail.gmail.com>
 <20130605110434.GY8923@twins.programming.kicks-ass.net>
 <CAKohpomJOGKoX9+HWkiGshUwTG9yKbn=M25xJvEYVZGnmj9Bkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomJOGKoX9+HWkiGshUwTG9yKbn=M25xJvEYVZGnmj9Bkg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 06:12:15PM +0530, Viresh Kumar wrote:
> On 5 June 2013 16:34, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, Jun 05, 2013 at 10:37:29AM +0530, Viresh Kumar wrote:
> 
> >> See if below one looks better (Attached too in case gmail screws up
> >> my mail)..
> 
> > Applying patch
> > patches/viresh_kumar-_patch__sched-optimize_build_sched_domains_for_saving_first_sd.patch
> > patching file kernel/sched/core.c
> > patch: **** malformed patch at line 56: cpumask *cpu_map,
> 
> You tried to apply patch from mail or attachment? I requested to
> pick attachment as gmail's copy-paste screws up patches.
> 

>From email; that's what my mailer is scripted for. TBH I didn't even
notice the attachment.

I'll go prod at the attachment.
