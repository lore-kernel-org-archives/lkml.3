Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3CSLmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:42:37 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:62739 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab3CSLmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:42:35 -0400
Message-ID: <51484F26.1010100@linaro.org>
Date: Tue, 19 Mar 2013 12:42:30 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john.stultz@linaro.org, linus.walleij@stericsson.com,
        viresh.kumar@linaro.org, jacob.jun.pan@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        rickard.andersson@stericsson.com, vincent.guittot@linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3/4][V2] ARM: nomadik: add dynamic irq flag to the timer
References: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org> <513A0109.9060801@linaro.org> <alpine.LFD.2.02.1303081703160.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1303081703160.22263@ionos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 05:03 PM, Thomas Gleixner wrote:
> On Fri, 8 Mar 2013, Daniel Lezcano wrote:
> 
>>> Add the dynamic irq affinity feature to the timer clock device.
>>>
>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>> Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
>>> Acked-by: Rickard Andersson <rickard.andersson@stericsson.com>
>>> ---
>>
>> Hi Linus,
>>
>> AFAIU, you are ok with this patch, Rickard acked it and Vincent reviewed it.
>>
>> Thomas agreed to merge it into its tree as I requested because we will
>> need to wait for your tree to gain visibility to this new flag before
>> submitting this patch, which can take awhile.
>>
>> Could you please ack it if it is ok for you ?
> 
> I can provide a for-arm tree to pull as well. Either way fine with me.

Hi Thomas,

the patch 3/4 and 4/4 have been acked-by the different maintainers.

I saw you created a 'for-arm' branch (thanks), but the patches 3/4 and
4/4 aren't there. Did I missed something ?

Thanks
   -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

