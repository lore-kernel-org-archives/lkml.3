Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030791Ab3DSOq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:46:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36425 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030601Ab3DSOqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:46:24 -0400
Date: Fri, 19 Apr 2013 15:46:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 2/2] clocksource: arm_arch_timer: add boot and suspend
 sched_clock offset
Message-ID: <20130419144601.GC4855@localhost.cambridge.arm.com>
References: <1366313410-16692-1-git-send-email-robherring2@gmail.com>
 <1366313410-16692-2-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366313410-16692-2-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 08:30:10PM +0100, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Commit 023796b (ARM: arch_timer: use full 64-bit counter for sched_clock)
> fails to ensure sched_clock always starts at time 0 and counting is
> suspended during suspend. arm64 sched_clock support also has the same
> issues. This fixes all architected timer users by maintaining an initial
> offset which is updated on resume.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Stephen Boyd <sboyd@codeaurora.org>

For arm64:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
