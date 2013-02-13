Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab3BMJ6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:58:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58912 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab3BMJ6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:58:03 -0500
MIME-Version: 1.0
In-Reply-To: <20130213092101.GD7630@gmail.com>
References: <1359907275-15410-1-git-send-email-anish198519851985@gmail.com>
	<CAK7N6vpT_X7s7Vid0-EYenb0w7k=nL8d-ov=fExFMuSYcV47Wg@mail.gmail.com>
	<20130213092101.GD7630@gmail.com>
Date: Wed, 13 Feb 2013 15:28:00 +0530
Message-ID: <CAK7N6vqh_c31bWiHgVgJLLckya7mykshMKYiqLTdkScMCoXcsg@mail.gmail.com>
Subject: Re: [PATCH] [Watchdog][Trivial] Added comments to explain
 watchdog_disabled variable
From: anish singh <anish198519851985@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: akpm@linux-foundation.org, dzickus@redhat.com, tglx@linutronix.de,
        chuansheng.liu@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 2:51 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * anish singh <anish198519851985@gmail.com> wrote:
>
>> Is the below patch picked up?
>>
>> On Sun, Feb 3, 2013 at 9:31 PM, anish kumar <anish198519851985@gmail.com> wrote:
>> > From: anish kumar <anish198519851985@gmail.com>
>> >
>> > This watchdog_disabled flag is bit of cryptic.Howerver it's usefullnes is multifold.
>> > Uses are:
>> > 1. Check if smpboot_register_percpu_thread function passed.
>> > 2. Makes sure that user enables and disables the watchdog in sequence
>> >    i.e. enable watchdog->disable watchdog->enable watchdog
>> >    Unlike enable watchdog->enable watchdog which is wrong.
>> >
>> > Signed-off-by: anish kumar <anish198519851985@gmail.com>
>> > ---
>> >  kernel/watchdog.c |    5 +++++
>> >  1 files changed, 5 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
>> > index 75a2ab3..87a19aa 100644
>> > --- a/kernel/watchdog.c
>> > +++ b/kernel/watchdog.c
>> > @@ -518,6 +518,11 @@ int proc_dowatchdog(struct ctl_table *table, int write,
>> >                 return ret;
>> >
>> >         set_sample_period();
>> > +       /*
>> > +        * We shouldn't enable watchdog threads if it is
>> > +        * disabled.This is done by watchdog_disabled
>> > +        * variable check in watchdog_*_all_cpus function.
>
> It has two grammatic and a stylistic error in it, plus misses
Would you mind pointing it out to me the grammatical mistakes
as I am not that good with grammar.
I thought I followed the conventions as below:
/*
 *
 *
 */
> the convention that function names are mentioned with a '()'.
>
> Thanks,
>
>         Ingo
