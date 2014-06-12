Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaFLQ6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:58:10 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:35315 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbaFLQ6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:58:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140612165530.GA14019@kroah.com>
References: <1402569495-11308-1-git-send-email-pramod.gurav.etc@gmail.com>
	<20140612165530.GA14019@kroah.com>
Date: Thu, 12 Jun 2014 22:28:07 +0530
Message-ID: <CAMf-jSmPquMo2woLtRn5JO6gU6p-G-O+o8NSsFWHaTRrHMCvHQ@mail.gmail.com>
Subject: Re: [PATCH] staging: alarm-dev: Support to Compile as Module
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 10:25 PM, Greg Kroah-Hartman <greg@kroah.com> wrote:
> On Thu, Jun 12, 2014 at 04:08:15PM +0530, pramod.gurav.etc@gmail.com wrote:
>> From: Pramod Gurav <pramod.gurav.etc@gmail.com>
>>
>> Currently this alarm-dev can be compiles only as built in
>> driver. This adds support to compile it as module as well.
>> This has dependancy on:
>> https://lkml.org/lkml/2014/6/12/180
>>
>> which exports symbol of alarmtimer function.
>>
>> CC: Greg Kroah-Hartman <greg@kroah.com>
>> CC: Brian Swetland <swetland@google.com>
>> Signed-off-by: Pramod Gurav <pramod.gurav.etc@gmail.com>
>> ---
>>  drivers/staging/android/Kconfig |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
>> index 99e484f..c359317 100644
>> --- a/drivers/staging/android/Kconfig
>> +++ b/drivers/staging/android/Kconfig
>> @@ -76,7 +76,7 @@ config ANDROID_LOW_MEMORY_KILLER
>>         Registers processes to be killed when memory is low
>>
>>  config ANDROID_INTF_ALARM_DEV
>> -     bool "Android alarm driver"
>> +     tristate "Android alarm driver"
>>       depends on RTC_CLASS
>>       default n
>>       ---help---
>
> Please resend the first patch (it's not a "trivial one") as part of this
> patch series.
>
Sure, Greg. will resend it.
> And do you ever really want this code as a module?  What will auto-load
> it if needed?
>

The TODO of staging/android/ says 'make sure they all build well as
modules'. So thought of build testing it. It failed and tried to fix
it.
> thanks,
>
> greg k-h



-- 
Thanks and Regards
Pramod
