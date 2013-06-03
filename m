Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3FCIji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:39:38 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:59654 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3FCIjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:39:32 -0400
Message-ID: <51AC5640.5060202@linaro.org>
Date: Mon, 03 Jun 2013 10:39:28 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Barry Song <baohua.song@csr.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv6 00/11] Remove ARM local timer API
References: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org> <20130531174526.GD599@codeaurora.org> <51A8E71D.1000407@linaro.org> <20130531221633.GG599@codeaurora.org>
In-Reply-To: <20130531221633.GG599@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 12:16 AM, Stephen Boyd wrote:
> On 05/31, John Stultz wrote:
>> On 05/31/2013 10:45 AM, Stephen Boyd wrote:
>>> Comments have been light for this round so I think we're about
>>> ready to merge. John/Thomas, can you pick up these patches or
>>> shall I route them through arm-soc or something else?
>>
>>
>> So there looks to be a fair amount of additions in the ARM tree, do
>> those already have acks from Arnd/Olof/other folks? (I think I was
>> only cc'ed on the first two patches).
> 
> I'm still missing acks from Kukjin and Barry.
> 
>>
>> Daniel (cc'ed) has just started helping out here, and should be able
>> to review and hopefully ack or pick up the timer related
>> drivers/clocksource changes to feed to Thomas' tree. Not sure if
>> he's got them in his mailbox so you might want to resend them and
>> make sure he's CC'ed.
>>
>> If Arnd/Olof/whomever else from the arm side has acked things,
>> Daniel probably could queue the arm changes too, but it might be
>> better just to get Daniel's ack on the drivers/clocksource changes
>> and then queue things via arm-soc?
> 
> Either way works for me. I would just like to see this merged
> into 3.11. I guess I will resend one more time.

Yes please, resend. I will review them.

queuing the patches via arm-soc makes sense for me, but I prefer to
review them before we decide to which tree we get them merged.

Thanks
 -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

