Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbaD3IwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:52:03 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:42431 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbaD3Iv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:51:58 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Date: Wed, 30 Apr 2014 14:21:57 +0530
Message-ID: <CAKohpo=dOYGXjTpRoBJp8mUkgJk0DaSBwknuhEtOyf+t9hK68w@mail.gmail.com>
Subject: Re: [PATCH V2 00/36] timers/hrtimers: Cleanups & Fixes
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Linaro Networking <linaro-networking@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 April 2014 12:05, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> I know you are not going to look at these before end of this merge window and
> you wanted to have a look at V1 before me posting these. But I am reposting them
> now due to these reasons:
> - Need to resend my cpu isolation (cpuset.quiesce) patches which are based of
>   these
> - Few patches are dropped/merged/fixed/updated and so all the patches from V1
>   wouldn't have made sense
> - There were some new patches as well which I wanted to send
>
> These have gone through fair bit of testing via kbuild system maintained by
> Fengguang Wu.
>
>
> These are some minor cleanups and potential bug fixes in there. These are based
> of tip/timers-core-for-linus ..
>
> V1 of most of these patches (~28) were posted here:
> https://lkml.org/lkml/2014/3/26/107
> https://lkml.org/lkml/2014/3/28/148
>
> V1->V2:
> - few new patches:
>   - patches around for_each_active_base()
>   - hrtimer: call switch_hrtimer_base() after setting new expiry time
>   - Some other minor cleanups
> - few patches are dropped
> - few are merged together as they covered same stuff
> - rebased all patches and moved the patches removing parameters or return values
>   at the bottom, so that others can be applied easily. Though as per my last
>   mail, it doesn't look like they are making the 'text' segments any bigger.

Any inputs on these ?
