Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab3FXJlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:41:17 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:47013 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3FXJlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:41:16 -0400
MIME-Version: 1.0
In-Reply-To: <24083337.GLRAoa2hpo@vostro.rjw.lan>
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com>
	<5527616.jZ71Fx7IV6@vostro.rjw.lan>
	<CAKohponvcqJvU1KKkK0EymcLjjLsC9_=z1oSDsKbJdyWf8SB9Q@mail.gmail.com>
	<24083337.GLRAoa2hpo@vostro.rjw.lan>
Date: Mon, 24 Jun 2013 15:11:15 +0530
Message-ID: <CAKohpo=q+2ULzOSeipjb8xS6NZBJLbR8AMptVcufD1vzULJGGw@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2013 15:09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, June 24, 2013 11:48:22 AM Viresh Kumar wrote:
>> On 21 June 2013 18:43, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > Well, to be honest, I don't like the whole thing.  The more changes you need
>> > to make to the common code to support it, the worse.
>>
>> You meant you didn't like this patch completely? Or the idea that
>> I gave?
>
> Well, kind of both ...
>
>> Getting the new frequency would be very useful IMHO. That would
>> give us a relation between old/new freq and load on each cpu at
>> that time. That's why I suggested it.
>
> Where "us" is user space or what?

User space as well as the developers who are accessing this information.
