Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936112Ab3DHUec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:34:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935818Ab3DHUea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:34:30 -0400
Message-ID: <516329D2.1050003@redhat.com>
Date: Mon, 08 Apr 2013 16:34:26 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] hrtimer, add expiry time overflow check in hrtimer_interrupt
References: <1365425235-26191-1-git-send-email-prarit@redhat.com> <5163264B.3050707@linaro.org>
In-Reply-To: <5163264B.3050707@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/08/2013 04:19 PM, John Stultz wrote:
> On 04/08/2013 05:47 AM, Prarit Bhargava wrote:

>>
>> A simple check for an overflow can resolve this problem.  Using KTIME_MAX
>> instead of the overflow value will result in the hrtimer function being run,
>> and the reprogramming of the timer after that.
>>
>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: John Stultz <john.stultz@linaro.org>
> 
> Prarit: Should this be tagged for -stable?

John,

Yes, this should go to -stable.  cc'd.

P.

> 
> thanks
> -john
> 
