Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881Ab3DHUiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:38:51 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39265 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964857Ab3DHUir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:38:47 -0400
Message-ID: <51632AD3.5030906@linaro.org>
Date: Mon, 08 Apr 2013 13:38:43 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] hrtimer, add expiry time overflow check in hrtimer_interrupt
References: <1365425235-26191-1-git-send-email-prarit@redhat.com> <5163264B.3050707@linaro.org> <516329D2.1050003@redhat.com>
In-Reply-To: <516329D2.1050003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 01:34 PM, Prarit Bhargava wrote:
>
> On 04/08/2013 04:19 PM, John Stultz wrote:
>> On 04/08/2013 05:47 AM, Prarit Bhargava wrote:
>>> A simple check for an overflow can resolve this problem.  Using KTIME_MAX
>>> instead of the overflow value will result in the hrtimer function being run,
>>> and the reprogramming of the timer after that.
>>>
>>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: John Stultz <john.stultz@linaro.org>
>> Prarit: Should this be tagged for -stable?
> John,
>
> Yes, this should go to -stable.  cc'd.
Also, added the cc to the commit.

thanks
-john

