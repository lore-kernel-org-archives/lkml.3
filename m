Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaJKRYC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 13:24:02 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:38596 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaJKRYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 13:24:00 -0400
Message-ID: <543967AC.6070507@gmail.com>
Date: Sat, 11 Oct 2014 19:23:56 +0200
From: Rasmus Wriedt Larsen <rasmuswriedtlarsen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: pdeschrijver@nvidia.com, rmk+kernel@arm.linux.org.uk, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: calibrate: fix style issues
References: <1413045075-10416-1-git-send-email-rasmuswriedtlarsen@gmail.com> <1413045605.16385.25.camel@joe-AO725>
In-Reply-To: <1413045605.16385.25.camel@joe-AO725>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/14 18:40, Joe Perches wrote:
> On Sat, 2014-10-11 at 18:31 +0200, Rasmus Wriedt Larsen wrote:
>> * fix multiple quoted string split across lines style issues
>> * change printk(KERN_NOTICE to pr_notice
>> * insert spaces after , in function call
> []
>> diff --git a/init/calibrate.c b/init/calibrate.c
> []
>> @@ -160,9 +158,7 @@ static unsigned long calibrate_delay_direct(void)
>>  
>>  	}
>>  
>> -	printk(KERN_NOTICE "calibrate_delay_direct() failed to get a good "
>> -	       "estimate for loops_per_jiffy.\nProbably due to long platform "
>> -		"interrupts. Consider using \"lpj=\" boot option.\n");
>> +	pr_notice("calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.\nProbably due to long platform interrupts. Consider using \"lpj=\" boot option.\n");
> 
> This would be better on 2 lines:
> 	pr_notice("calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.\n"
> 		  "Probably due to long platform interrupts. Consider using \"lpj=\" boot option.\n");

Yes, indeed it would. (will fix in upcoming patch)

> The grammar is poor though and this
> could be better phrased.

Any suggestions? I don't see anything in particular (but English is not my
native language either)
