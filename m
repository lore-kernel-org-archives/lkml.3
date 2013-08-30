Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab3H3OEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:04:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47013 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755805Ab3H3OEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:04:48 -0400
Date: Fri, 30 Aug 2013 15:04:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v6 0/5] ARM/ARM64 architected timer updates
Message-ID: <20130830140406.GE12160@mudshark.cambridge.arm.com>
References: <1377788142-21388-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <52206EE0.5020907@arm.com>
 <20130830114309.GW6617@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830114309.GW6617@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 12:43:09PM +0100, Russell King - ARM Linux wrote:
> On Fri, Aug 30, 2013 at 11:07:28AM +0100, Sudeep KarkadaNagesha wrote:
> > On 29/08/13 15:55, Sudeep KarkadaNagesha wrote:
> > > From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> > > 
> > > This patch series adds support to configure the rate and enable the
> > > event stream for architected timer. The event streams can be used to
> > > impose a timeout on a wfe, to safeguard against any programming error
> > > in case an expected event is not generated or even to implement
> > > wfe-based timeouts for userspace locking implementations. This feature
> > > can be disabled(enabled by default).
> > > 
> > > Since the timer control register is reset to zero on warm boot, CPU
> > > PM notifier is added to save and restore the value.
> > > 
> > Hi Russell,
> > 
> > Can you have a look at this series ?
> > If you are OK, can I have your ACK on arm specific changes(PATCH 2/5) ?
> 
> I think it would be more value to have someone from ARM Ltd ack it,
> because they will know the code much better than I do.

Looks good to me, so for patch 2/5:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
