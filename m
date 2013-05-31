Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab3EaXuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 19:50:12 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44127 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab3EaXuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 19:50:07 -0400
Message-ID: <51A9372C.8060107@linaro.org>
Date: Fri, 31 May 2013 16:50:04 -0700
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
References: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org> <1367369675-13535-1-git-send-email-sboyd@codeaurora.org> <51A90ACE.7070906@linaro.org> <20130531221358.GF599@codeaurora.org>
In-Reply-To: <20130531221358.GF599@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 03:13 PM, Stephen Boyd wrote:
> On 05/31, John Stultz wrote:
>> On 04/30/2013 05:54 PM, Stephen Boyd wrote:
>>> Here's the patch to make sched_clock generic. I didn't know
>>> where to put it so I just made a new file in kernel/sched
>>> for now.
>>>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> Hey Stephen,
>>      Baruch just asked a question about moving arm's sched_clock.c to
>> be generic, and it sounded familiar, so I dug around and found this
>> mail from a few months ago.
>>
>> Just wanted to follow up and see what the status is with this? Is
>> this queued somewhere already?
>>
> As far as I know nothing has been queued. I refreshed the
> patchset against 3.10-rc2 but haven't sent it out since it wasn't
> clear if anyone wanted it. Shall I send it again?

Please. Even if it need an eventual deeper rework to be totally generic, 
I think we need to start moving things in that generic direction. 
Baruch's case is a clear example where non-arm code could share it, so I 
think that's at least a good proof point that sharing is actually needed 
(rather then just for theoretical reasons).

thanks
-john

