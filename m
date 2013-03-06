Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab3CFLrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:47:09 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34609 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab3CFLrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:47:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130218204858.GB98867@redhat.com>
References: <1361016849-5181-1-git-send-email-anish198519851985@gmail.com>
	<20130218204858.GB98867@redhat.com>
Date: Wed, 6 Mar 2013 17:17:04 +0530
Message-ID: <CAK7N6vqjvVprjxUiqtkxvF6kJ5SV0tUvOggxCOdEC9eSqYLcuA@mail.gmail.com>
Subject: Re: [PATCH] [Watchdog][Trivial] Added comments to explain
 watchdog_disabled variable
From: anish singh <anish198519851985@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: akpm@linux-foundation.org, mingo@kernel.org, chuansheng.liu@intel.com,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 2:18 AM, Don Zickus <dzickus@redhat.com> wrote:
> On Sat, Feb 16, 2013 at 05:44:09PM +0530, anish kumar wrote:
>> From: anish kumar <anish198519851985@gmail.com>
>>
>> This watchdog_disabled flag is bit of cryptic.Howerver it's usefullnes is multifold.
>> Uses are:
>> 1. Check if smpboot_register_percpu_thread function passed.
>> 2. Makes sure that user enables and disables the watchdog in sequence
>>    i.e. enable watchdog->disable watchdog->enable watchdog
>>    Unlike enable watchdog->enable watchdog which is wrong.
>>
>> Signed-off-by: anish kumar <anish198519851985@gmail.com>
>> ---
>>  kernel/watchdog.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
>> index 75a2ab3..8a20ebe 100644
>> --- a/kernel/watchdog.c
>> +++ b/kernel/watchdog.c
>> @@ -518,6 +518,11 @@ int proc_dowatchdog(struct ctl_table *table, int write,
>>               return ret;
>>
>>       set_sample_period();
>> +     /*
>> +      * Watchdog threads shouldn't be enabled if they are
>> +      * disabled.'watchdog_disabled' variable check in
>
> Missing a 'The'  ^^^
>
> Other than that,
>
> Acked-by: Don Zickus <dzickus@redhat.com>
Is this patch picked up?
