Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3EaWOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:14:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33716 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3EaWN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:13:59 -0400
Date: Fri, 31 May 2013 15:13:58 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH 5/4] sched: Make ARM's sched_clock generic for all
 architectures
Message-ID: <20130531221358.GF599@codeaurora.org>
References: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
 <1367369675-13535-1-git-send-email-sboyd@codeaurora.org>
 <51A90ACE.7070906@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A90ACE.7070906@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, John Stultz wrote:
> On 04/30/2013 05:54 PM, Stephen Boyd wrote:
> >Here's the patch to make sched_clock generic. I didn't know
> >where to put it so I just made a new file in kernel/sched
> >for now.
> >
> >Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Hey Stephen,
>     Baruch just asked a question about moving arm's sched_clock.c to
> be generic, and it sounded familiar, so I dug around and found this
> mail from a few months ago.
> 
> Just wanted to follow up and see what the status is with this? Is
> this queued somewhere already?
> 

As far as I know nothing has been queued. I refreshed the
patchset against 3.10-rc2 but haven't sent it out since it wasn't
clear if anyone wanted it. Shall I send it again?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
