Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaKXSls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:41:48 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34918 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbaKXSlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:41:46 -0500
MIME-Version: 1.0
In-Reply-To: <20141124104530.78a0050e@lwn.net>
References: <1416847159-3895-1-git-send-email-sj38.park@gmail.com> <20141124104530.78a0050e@lwn.net>
From: SeongJae Park <sj38.park@gmail.com>
Date: Tue, 25 Nov 2014 03:41:15 +0900
Message-ID: <CAEjAshqxpgAsO69zkNkb-CgbofHtXDriKP3CWwDeEcZJLF6jwA@mail.gmail.com>
Subject: Re: [PATCH] cgroups: Documentation: fix wrong cgroupfs paths
To: Jonathan Corbet <corbet@lwn.net>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 2:45 AM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Tue, 25 Nov 2014 01:39:19 +0900
> SeongJae Park <sj38.park@gmail.com> wrote:
>
>>   6) Attach that task to the new cgroup by writing its PID to the
>> -    /sys/fs/cgroup/cpuset/tasks file for that cgroup.
>> +    /sys/fs/cgroup/cpuset tasks file for that cgroup.
>
> That one looks like it was correct before the change...?  What am I
> missing here?

It should represents /sys/fs/cgroup/cpuset/<*new cgroup name*>/tasks,
not /sys/fs/cgroup/cpuset/tasks.

If there are better suggestions or anything I am missing, please let me
know.

Thanks,
SeongJae Park

>
> Thanks,
>
> jon
