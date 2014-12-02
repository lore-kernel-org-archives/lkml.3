Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbaLBTO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:14:27 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41405 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaLBTOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:14:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvybiem34J3zrtVhW=4itSdczassNt9RcuxnpJQeAz-JVA@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <20141104131030.GA2937@redhat.com> <CAGr1F2Hm4+aCUz3RqkgUhbJAQtWvUbb2CRDkW5rJSZkwLM_huw@mail.gmail.com>
 <CAFLxGvybiem34J3zrtVhW=4itSdczassNt9RcuxnpJQeAz-JVA@mail.gmail.com>
From: Aditya Kali <adityakali@google.com>
Date: Tue, 2 Dec 2014 11:14:04 -0800
Message-ID: <CAGr1F2F97LcORP6mbEfC+kU0Eib8AWt=n25Ok5EM5U_HB=DfsQ@mail.gmail.com>
Subject: Re: [PATCHv2 0/7] CGroup Namespaces
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 2:58 PM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
>
> On Thu, Nov 6, 2014 at 6:33 PM, Aditya Kali <adityakali@google.com> wrote:
> > On Tue, Nov 4, 2014 at 5:10 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> On Fri, Oct 31, 2014 at 12:18:54PM -0700, Aditya Kali wrote:
> >> [..]
> >>>  fs/kernfs/dir.c                  | 194 ++++++++++++++++++++++++++++++++++-----
> >>>  fs/kernfs/mount.c                |  48 ++++++++++
> >>>  fs/proc/namespaces.c             |   1 +
> >>>  include/linux/cgroup.h           |  41 ++++++++-
> >>>  include/linux/cgroup_namespace.h |  36 ++++++++
> >>>  include/linux/kernfs.h           |   5 +
> >>>  include/linux/nsproxy.h          |   2 +
> >>>  include/linux/proc_ns.h          |   4 +
> >>>  include/uapi/linux/sched.h       |   3 +-
> >>>  kernel/Makefile                  |   2 +-
> >>>  kernel/cgroup.c                  | 108 +++++++++++++++++-----
> >>>  kernel/cgroup_namespace.c        | 148 +++++++++++++++++++++++++++++
> >>>  kernel/fork.c                    |   2 +-
> >>>  kernel/nsproxy.c                 |  19 +++-
> >>
> >> Hi Aditya,
> >>
> >> Can we provide a documentation file for cgroup namespace behavior. Say,
> >> Documentation/namespaces/cgroup-namespace.txt.
> >>
> > Yes, definitely. I will add it as soon as we have a consensus on the
> > overall series.
>
> Do you have a public git repository which contains your patches?
>

Hi, Sorry for late reply. I don't have these in a public git repo yet.
But I will try to post it on github or somewhere.
Also, I found a bug in this patchset that crashes the kernel in some
cases (when both unified and split hierarchies are mounted). I have a
fix and will send out the patches (with documentation) soon.

>
> --
> Thanks,
> //richard

Thanks,
-- 
Aditya
