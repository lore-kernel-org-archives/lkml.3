Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936690Ab3DHKY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:24:58 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41038 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936663Ab3DHKYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAOS58YOvDGavhffFawMbk1Y4xihL3OwPSpOkEzXKSzORvjyq-Q@mail.gmail.com>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
	<91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
	<20130331181931.GA7533@htj.dyndns.org>
	<CAKohpo=nWsUh5y7y_tacGez7uN76QbRFRVPSQcKQMGM1nUBWtw@mail.gmail.com>
	<20130403215412.GG3411@htj.dyndns.org>
	<CAKohpomTQj-S-32JdtY76_82NraB5uBqnKZXVxk28KxMZ-NSow@mail.gmail.com>
	<CAOS58YOvDGavhffFawMbk1Y4xihL3OwPSpOkEzXKSzORvjyq-Q@mail.gmail.com>
Date: Mon, 8 Apr 2013 15:54:51 +0530
Message-ID: <CAKohpom5O+6iN-phuiFXRaBY8O8ZzUGyXKeiRnyj9Z8BR90SEg@mail.gmail.com>
Subject: Re: [PATCH V4 3/4] block: queue work on unbound wq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        "David S. Miller" <davem@davemloft.net>, airlied@redhat.com,
        Jens Axboe <axboe@kernel.dk>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 April 2013 17:52, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Apr 5, 2013 at 2:47 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> module_param()?? We can't compile kernel/workqueue.c as a module and
>> hence i went with #define + a variable with functions to set/reset it...
>
> module_param works fine for kernel proper.

Got it!! Btw, to which Kconfig should i add WQ config option?
