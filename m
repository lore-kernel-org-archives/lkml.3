Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaEEUZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:25:07 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54868 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaEEUZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:25:05 -0400
Message-ID: <5367F39C.1050703@linaro.org>
Date: Mon, 05 May 2014 13:25:00 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 0/4] Convert timekeeping core to use printk_deferred (v2)
References: <1399068558-2373-1-git-send-email-john.stultz@linaro.org>	<20140502160536.892e6aff76df3398529d09ad@linux-foundation.org> <20140505144231.654d85b0@gandalf.local.home>
In-Reply-To: <20140505144231.654d85b0@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 11:42 AM, Steven Rostedt wrote:
> On Fri, 2 May 2014 16:05:36 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>  
>> Would "printk_deferred_once" be more logical than
>> "printk_once_deferred"?  Think so.  It's (((printk(deferred(once))),
>> not (((printk(once(deferred))).
>>
> I agree with the above, but other than that you can add my:
>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Thanks, will do!

>
> also, perhaps this series should include my patch:
>
> https://lkml.org/lkml/2014/3/25/336

So this set applies ontop of -mm, which I believe includes your change.

If I try to cherry-pick your patch to include in my set, I think I have
to cherry-pick Jan's changes as well, so its probably just easier for
folks to grab -mm. :)
thanks
-john
