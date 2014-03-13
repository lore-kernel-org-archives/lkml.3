Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaCMBlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 21:41:53 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:39769 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaCMBlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 21:41:51 -0400
Message-ID: <53210CCA.90907@linaro.org>
Date: Wed, 12 Mar 2014 20:41:30 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, wim@iguana.be
CC: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: fix ARCH_BCM_MOBILE dependency
References: <1394662322-12445-1-git-send-email-elder@linaro.org> <5320F516.5080707@roeck-us.net>
In-Reply-To: <5320F516.5080707@roeck-us.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 07:00 PM, Guenter Roeck wrote:
> On 03/12/2014 03:12 PM, Alex Elder wrote:
>> Starting with this commit:
>>      047ef2fa rename ARCH_BCM to ARCH_BCM_MOBILE (clocksource)
>> the meaning of the ARCH_BCM config option is changed to represent
>> all Broadcom chips with code in the mach-bcm directory.
>>
>> Configuration options related to specific Broadcom platforms should
>> now use another symbol (currently ARCH_BCM_MOBILE, ARCH_BCM2835, or
>> ARCH_BCM_5301X).
>>
>> The BCM_KONA_WDT config option indicates a dependency on ARCH_BCM,
>> but it should be ARCH_BCM_MOBILE instead.  Fix that.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> Hi Alex,
> 
> Markus Mayer already submitted a similar patch:
>     http://patchwork.roeck-us.net/patch/1263/

Yes someone else pointed that out to me shortly
after I sent mine.  I wasn't aware he had done it.
I discovered the problem independently today and
just sent out the fix.  Thanks.

					-Alex

