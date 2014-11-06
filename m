Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaKFReJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:34:09 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:52275 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaKFReH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:34:07 -0500
MIME-Version: 1.0
In-Reply-To: <20141104131030.GA2937@redhat.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com> <20141104131030.GA2937@redhat.com>
From: Aditya Kali <adityakali@google.com>
Date: Thu, 6 Nov 2014 09:33:45 -0800
Message-ID: <CAGr1F2Hm4+aCUz3RqkgUhbJAQtWvUbb2CRDkW5rJSZkwLM_huw@mail.gmail.com>
Subject: Re: [PATCHv2 0/7] CGroup Namespaces
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 5:10 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Oct 31, 2014 at 12:18:54PM -0700, Aditya Kali wrote:
> [..]
>>  fs/kernfs/dir.c                  | 194 ++++++++++++++++++++++++++++++++++-----
>>  fs/kernfs/mount.c                |  48 ++++++++++
>>  fs/proc/namespaces.c             |   1 +
>>  include/linux/cgroup.h           |  41 ++++++++-
>>  include/linux/cgroup_namespace.h |  36 ++++++++
>>  include/linux/kernfs.h           |   5 +
>>  include/linux/nsproxy.h          |   2 +
>>  include/linux/proc_ns.h          |   4 +
>>  include/uapi/linux/sched.h       |   3 +-
>>  kernel/Makefile                  |   2 +-
>>  kernel/cgroup.c                  | 108 +++++++++++++++++-----
>>  kernel/cgroup_namespace.c        | 148 +++++++++++++++++++++++++++++
>>  kernel/fork.c                    |   2 +-
>>  kernel/nsproxy.c                 |  19 +++-
>
> Hi Aditya,
>
> Can we provide a documentation file for cgroup namespace behavior. Say,
> Documentation/namespaces/cgroup-namespace.txt.
>
Yes, definitely. I will add it as soon as we have a consensus on the
overall series.

> Namespaces are complicated and it might be a good idea to keep one .txt
> file for each namespace.
>
> Thanks
> Vivek


Thanks,
-- 
Aditya
