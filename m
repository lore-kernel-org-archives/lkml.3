Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224Ab3EAJMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 05:12:42 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50013 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757427Ab3EAJMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 05:12:33 -0400
Date: Wed, 1 May 2013 10:11:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "arm@kernel.org" <arm@kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/4] arm64: Move to generic sched_clock infrastructure
Message-ID: <20130501091108.GB10984@arm.com>
References: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
 <1367369675-13535-1-git-send-email-sboyd@codeaurora.org>
 <1367369675-13535-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367369675-13535-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 01:54:35AM +0100, Stephen Boyd wrote:
> Use the generic sched_clock infrastructure instead of rolling our
> own. This has the added benefit of fixing suspend/resume as
> outlined in 6a4dae5 (ARM: 7565/1: sched: stop sched_clock()
> during suspend, 2012-10-23) and correcting the timestamps when
> the hardware returns a value instead of 0 upon the first read.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Looks ok.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
