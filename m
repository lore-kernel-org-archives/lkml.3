Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab3EaWQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:16:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33870 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3EaWQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:16:34 -0400
Date: Fri, 31 May 2013 15:16:33 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Barry Song <baohua.song@csr.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv6 00/11] Remove ARM local timer API
Message-ID: <20130531221633.GG599@codeaurora.org>
References: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org>
 <20130531174526.GD599@codeaurora.org>
 <51A8E71D.1000407@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A8E71D.1000407@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, John Stultz wrote:
> On 05/31/2013 10:45 AM, Stephen Boyd wrote:
> >Comments have been light for this round so I think we're about
> >ready to merge. John/Thomas, can you pick up these patches or
> >shall I route them through arm-soc or something else?
> 
> 
> So there looks to be a fair amount of additions in the ARM tree, do
> those already have acks from Arnd/Olof/other folks? (I think I was
> only cc'ed on the first two patches).

I'm still missing acks from Kukjin and Barry.

> 
> Daniel (cc'ed) has just started helping out here, and should be able
> to review and hopefully ack or pick up the timer related
> drivers/clocksource changes to feed to Thomas' tree. Not sure if
> he's got them in his mailbox so you might want to resend them and
> make sure he's CC'ed.
> 
> If Arnd/Olof/whomever else from the arm side has acked things,
> Daniel probably could queue the arm changes too, but it might be
> better just to get Daniel's ack on the drivers/clocksource changes
> and then queue things via arm-soc?

Either way works for me. I would just like to see this merged
into 3.11. I guess I will resend one more time.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
