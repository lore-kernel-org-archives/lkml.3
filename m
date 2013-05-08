Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3EHALp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 20:11:45 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:63243 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3EHALo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 20:11:44 -0400
Message-ID: <5189983B.3090400@linaro.org>
Date: Tue, 07 May 2013 17:11:39 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Liu Ying <Ying.Liu@freescale.com>
CC: linux-kernel@vger.kernel.org, davem@davemloft.net, dborkman@redhat.com,
        tglx@linutronix.de, liu.y.victor@gmail.com
Subject: Re: [PATCH v2] ktime: Use macro NSEC_PER_USEC where appropriate
References: <1367915920-13485-1-git-send-email-Ying.Liu@freescale.com>
In-Reply-To: <1367915920-13485-1-git-send-email-Ying.Liu@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 01:38 AM, Liu Ying wrote:
> We've got the macro NSEC_PER_USEC defined in header file
> include/linux/time.h. To make the code decent, this patch
> replaces the immediate number 1000 to convert bewteen a
> time value in microseconds and one in nanoseconds with the
> macro NSEC_PER_USEC.
>
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Daniel Borkmann <dborkman@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> ---
> Changes for v2:
> 1. Update commit head and message to be more appropriate.
> 2. Avoid an unnecessary cast in the function
>     timeval_to_ktime().

I've gone ahead and queued this for 3.11.

thanks
-john

