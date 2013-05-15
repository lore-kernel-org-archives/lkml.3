Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3EOFtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 01:49:02 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:34527 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3EOFtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 01:49:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130514175440.GG6795@mtj.dyndns.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
	<20130514175440.GG6795@mtj.dyndns.org>
Date: Wed, 15 May 2013 11:18:59 +0530
Message-ID: <CAKohpo=oHXbHTWdj+J9OeV9ZHU3ii9u5UNcsrwOrJwkXbz_xkg@mail.gmail.com>
Subject: Re: [PATCH V5 0/5] Queue work on power efficient wq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 May 2013 23:24, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Apr 24, 2013 at 05:12:52PM +0530, Viresh Kumar wrote:
>> This patchset was called: "Create sched_select_cpu() and use it for workqueues"
>> for the first three versions.
>
> Applied to wq/for-3.11 with some updates to comments and
> documentation.  Will post the applied versions.  If something is awry,
> please let me know.

Thanks. All looks good.
