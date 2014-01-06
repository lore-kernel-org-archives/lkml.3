Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaAFL0C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:26:02 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42253 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaAFL0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:26:00 -0500
Message-ID: <52CA92C3.50200@linaro.org>
Date: Mon, 06 Jan 2014 12:25:55 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 0/7] sched: cleanup trigger_load_balance
References: <1388411093-3413-1-git-send-email-daniel.lezcano@linaro.org> <20131231162821.GE16438@laptop.programming.kicks-ass.net> <52C2FC88.6040903@linaro.org> <20140106110351.GE31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140106110351.GE31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 12:03 PM, Peter Zijlstra wrote:
> On Tue, Dec 31, 2013 at 06:19:04PM +0100, Daniel Lezcano wrote:
>> I understand. Happy new year !
>
> Happy new year to you too! :-)
>
>> ps : the patchset is based on tip/sched/core
>
> Weird; because tip/sched/core as per today looks like:
>
>
> 029632fbb7b7c kernel/sched_fair.c (Peter Zijlstra       2011-10-25 10:00:11 +0200 6872) void trigger_load_balance(struct rq *rq, int cpu)
>
> And your patches assume it looks like:
>
> Patch 1: @@ -6878,7 +6878,7 @@ void trigger_load_balance(struct rq *rq)
> Patch 2: @@ -6875,10 +6875,10 @@ void trigger_load_balance(struct rq *rq)
> Patch 4:
>   void trigger_load_balance(struct rq *rq)
>   {
> -       int cpu = rq->cpu;
> -
>
> Which obviously doesn't quite work..
>
>
> So I can make it fit.. but I do wonder what I'm missing here..


Ah, ok. I got it. I missed to send the first patch of my patchset:

sched: reduce trigger_load_balance parameters

Let me resend the patchset with the missing patch.

Sorry for the inconvenience

   -- Daniel



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

