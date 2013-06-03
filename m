Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab3FCUAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:00:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43511 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab3FCUAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:00:39 -0400
Message-ID: <51ACF5E5.80503@codeaurora.org>
Date: Mon, 03 Jun 2013 13:00:37 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Barry Song <baohua.song@csr.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv6 00/11] Remove ARM local timer API
References: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org> <20130531174526.GD599@codeaurora.org> <51A8E71D.1000407@linaro.org> <20130531221633.GG599@codeaurora.org> <51AC59AB.4080802@arm.com>
In-Reply-To: <51AC59AB.4080802@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/13 01:54, Marc Zyngier wrote:
> On 31/05/13 23:16, Stephen Boyd wrote:
>> On 05/31, John Stultz wrote:
>>> On 05/31/2013 10:45 AM, Stephen Boyd wrote:
>>>> Comments have been light for this round so I think we're about
>>>> ready to merge. John/Thomas, can you pick up these patches or
>>>> shall I route them through arm-soc or something else?
>>>
>>> So there looks to be a fair amount of additions in the ARM tree, do
>>> those already have acks from Arnd/Olof/other folks? (I think I was
>>> only cc'ed on the first two patches).
>> I'm still missing acks from Kukjin and Barry.
> I don't think that should hold off the patch series. It's been tested on
> most other platforms over the course of several months. If the platform
> maintainers aren't responsive enough, fixing the issues becomes their
> problem.
>
> FWIW, have my
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks Marc. Any particular patches or should I add this to all of them?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

