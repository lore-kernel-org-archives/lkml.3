Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3EaUk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:40:57 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45340 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3EaUkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:40:49 -0400
Message-ID: <51A90ACE.7070906@linaro.org>
Date: Fri, 31 May 2013 13:40:46 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH 5/4] sched: Make ARM's sched_clock generic for all architectures
References: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org> <1367369675-13535-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1367369675-13535-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 05:54 PM, Stephen Boyd wrote:
> Here's the patch to make sched_clock generic. I didn't know
> where to put it so I just made a new file in kernel/sched
> for now.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Hey Stephen,
     Baruch just asked a question about moving arm's sched_clock.c to be 
generic, and it sounded familiar, so I dug around and found this mail 
from a few months ago.

Just wanted to follow up and see what the status is with this? Is this 
queued somewhere already?

thanks
-john

