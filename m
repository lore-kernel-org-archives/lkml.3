Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab3DYAFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 20:05:08 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:40139 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491Ab3DYAFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 20:05:06 -0400
Message-ID: <5178732F.6060304@linaro.org>
Date: Wed, 24 Apr 2013 17:05:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] hrtimer, add expiry time overflow check in hrtimer_interrupt
References: <1365425235-26191-1-git-send-email-prarit@redhat.com> <5163264B.3050707@linaro.org> <516329D2.1050003@redhat.com> <20130424224218.GA7767@roeck-us.net>
In-Reply-To: <20130424224218.GA7767@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 03:42 PM, Guenter Roeck wrote:
> On Mon, Apr 08, 2013 at 04:34:26PM -0400, Prarit Bhargava wrote:
>>
>> On 04/08/2013 04:19 PM, John Stultz wrote:
>>> On 04/08/2013 05:47 AM, Prarit Bhargava wrote:
>>>> A simple check for an overflow can resolve this problem.  Using KTIME_MAX
>>>> instead of the overflow value will result in the hrtimer function being run,
>>>> and the reprogramming of the timer after that.
>>>>
>>>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: John Stultz <john.stultz@linaro.org>
>>> Prarit: Should this be tagged for -stable?
>> John,
>>
>> Yes, this should go to -stable.  cc'd.
>>
> Hi,
>
> I am a bit surprised that this patch has not found its way into mainline yet,
> as everyone seems to agree that it is a candidate for -stable.

It just has to land upstream first, which is likely in the next week or 
so when the 3.10 merge window opens. I'd have thought it would be sooner 
but 3.9 is taking longer to close then I expected (and I didn't think it 
was urgent enough to drop in at the last minute before the 3.9 release 
was made).

thanks
-john

