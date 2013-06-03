Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab3FCUGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:06:41 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:50886 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757332Ab3FCUGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:06:39 -0400
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCHv6 00/11] Remove ARM local timer API
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 03 Jun 2013 22:06:25 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tony Lindgren <tony@atomide.com>, <linux-arm-msm@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        <linux-kernel@vger.kernel.org>, Bryan Huntsman <bryanh@codeaurora.org>,
        <arm@kernel.org>, John Stultz <john.stultz@linaro.org>,
        Barry Song <baohua.song@csr.com>, Daniel Walker <dwalker@fifo99.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Organization: ARM Ltd
In-Reply-To: <51ACF5E5.80503@codeaurora.org>
References: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org> <20130531174526.GD599@codeaurora.org> <51A8E71D.1000407@linaro.org> <20130531221633.GG599@codeaurora.org> <51AC59AB.4080802@arm.com> <51ACF5E5.80503@codeaurora.org>
Message-ID: <86cfedeb1392a8eec888c96e9434fcb4@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: sboyd@codeaurora.org, Mark.Rutland@arm.com, kgene.kim@samsung.com, arnd@arndb.de, thomas.abraham@linaro.org, tony@atomide.com, linux-arm-msm@vger.kernel.org, daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org, bryanh@codeaurora.org, arm@kernel.org, john.stultz@linaro.org, baohua.song@csr.com, dwalker@fifo99.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Jun 2013 13:00:37 -0700, Stephen Boyd <sboyd@codeaurora.org>
wrote:
> On 06/03/13 01:54, Marc Zyngier wrote:
>> On 31/05/13 23:16, Stephen Boyd wrote:
>>> On 05/31, John Stultz wrote:
>>>> On 05/31/2013 10:45 AM, Stephen Boyd wrote:
>>>>> Comments have been light for this round so I think we're about
>>>>> ready to merge. John/Thomas, can you pick up these patches or
>>>>> shall I route them through arm-soc or something else?
>>>>
>>>> So there looks to be a fair amount of additions in the ARM tree, do
>>>> those already have acks from Arnd/Olof/other folks? (I think I was
>>>> only cc'ed on the first two patches).
>>> I'm still missing acks from Kukjin and Barry.
>> I don't think that should hold off the patch series. It's been tested
on
>> most other platforms over the course of several months. If the platform
>> maintainers aren't responsive enough, fixing the issues becomes their
>> problem.
>>
>> FWIW, have my
>> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> Thanks Marc. Any particular patches or should I add this to all of them?

All of them. I'm not that subtle... ;-)

        M.
-- 
Fast, cheap, reliable. Pick two.
