Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467Ab3EWOnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:43:20 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:39275 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759441Ab3EWOnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:43:18 -0400
Message-ID: <519E2B05.6060206@schinagl.nl>
Date: Thu, 23 May 2013 16:43:17 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130322 Thunderbird/17.0.4
MIME-Version: 1.0
To: Lars Poeschel <poeschel@lemonage.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] pwm: add sysfs interface
References: <519DDC5B.4040403@schinagl.nl> <201305231412.15096.poeschel@lemonage.de>
In-Reply-To: <201305231412.15096.poeschel@lemonage.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/13 14:12, Lars Poeschel wrote:
> Hi Oliver!
>
> As you are not the first one asking for the status of the pwm sysfs
> interface I post my answer to the linux-kernel list in hope others will
> benefit.
>
> On Thursday 23 May 2013 at 11:07:39, Oliver Schinagl wrote:
>> Hi lars,
>>
>> I have trouble seeing if your patch has been applied yet to the kernel
>> tree. I do see it in patchwork.
>> https://patchwork.kernel.org/patch/2163151/
>>
>> But don't see sysfs features in
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/dri
>> vers/pwm/core.c
>
> It is not merged and will never be.
>
>> If you haven't had time to take Greg's comments into account, would
>> there be a possibility for you to correct those and re-submit?
>
> I already did resubmit an updated version taking Greg's comments into
> account. You can find the thread here:
>
> http://marc.info/?l=linux-kernel&m=136499756101273&w=2
> https://patchwork.kernel.org/patch/2387391/
>
> Also this version will not get merged into mainline. I have to do a v2
> according to Thierry's comments. I have planed to do it, but I will not
> find the time during the next say 2 months.
Ok, keep me updated. If in the meantime I find time, I'll take the next 
set of comments into account and re-submit it, with a CC to you. If you 
hear nothing, don't let that hold you back ;)

>
>> If not, I'd be happy to pull your patch, fix and re-submit (giving you
>> full credit of course).
>
> You're welcome! This is a community project. And there is nothing special
> to pull or something. Just take the patch from patchwork and work on it.
>
>> Your sysfs driver feature is quite awesome and makes using PWM's quite
>> cool, so that's definitely a good feature to have in the kernel.
>
> Thanks!
> Thank you for your interest!
>
> Regards,
> Lars
>

