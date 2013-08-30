Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3H3Qh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:37:29 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:44753 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756214Ab3H3QhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:37:25 -0400
Date: Fri, 30 Aug 2013 17:35:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v6 0/5] ARM/ARM64 architected timer updates
Message-ID: <20130830163531.GH4650@arm.com>
References: <1377788142-21388-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <52206EE0.5020907@arm.com>
 <20130830114309.GW6617@n2100.arm.linux.org.uk>
 <20130830140406.GE12160@mudshark.cambridge.arm.com>
 <5220BE49.2030409@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5220BE49.2030409@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 04:46:17PM +0100, Sudeep KarkadaNagesha wrote:
> On 30/08/13 15:04, Will Deacon wrote:
> > On Fri, Aug 30, 2013 at 12:43:09PM +0100, Russell King - ARM Linux wrote:
> >> On Fri, Aug 30, 2013 at 11:07:28AM +0100, Sudeep KarkadaNagesha wrote:
> >>> On 29/08/13 15:55, Sudeep KarkadaNagesha wrote:
> >>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> >>>>
> >>>> This patch series adds support to configure the rate and enable the
> >>>> event stream for architected timer. The event streams can be used to
> >>>> impose a timeout on a wfe, to safeguard against any programming error
> >>>> in case an expected event is not generated or even to implement
> >>>> wfe-based timeouts for userspace locking implementations. This feature
> >>>> can be disabled(enabled by default).
> >>>>
> >>>> Since the timer control register is reset to zero on warm boot, CPU
> >>>> PM notifier is added to save and restore the value.
> >>>>
> >>> Hi Russell,
> >>>
> >>> Can you have a look at this series ?
> >>> If you are OK, can I have your ACK on arm specific changes(PATCH 2/5) ?
> >>
> >> I think it would be more value to have someone from ARM Ltd ack it,
> >> because they will know the code much better than I do.
> > 
> > Looks good to me, so for patch 2/5:
> > 
> >   Acked-by: Will Deacon <will.deacon@arm.com>
> > 
> Thanks Will and Russell.
> 
> Hi Catalin,
> 
> Can I have your ACK for ARM64 changes(PATCH 3/5) so that Daniel can
> accept my pull request ?

Well, I gave you my reviewed-by couple of times already. If you need
ack, here it is ;)

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
