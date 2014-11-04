Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaKDNLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:11:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaKDNK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:10:56 -0500
Date: Tue, 4 Nov 2014 08:10:30 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Aditya Kali <adityakali@google.com>
Cc: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, ebiederm@xmission.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com, containers@lists.linux-foundation.org
Subject: Re: [PATCHv2 0/7] CGroup Namespaces
Message-ID: <20141104131030.GA2937@redhat.com>
References: <adityakali-cgroupns>
 <1414783141-6947-1-git-send-email-adityakali@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414783141-6947-1-git-send-email-adityakali@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 12:18:54PM -0700, Aditya Kali wrote:
[..]
>  fs/kernfs/dir.c                  | 194 ++++++++++++++++++++++++++++++++++-----
>  fs/kernfs/mount.c                |  48 ++++++++++
>  fs/proc/namespaces.c             |   1 +
>  include/linux/cgroup.h           |  41 ++++++++-
>  include/linux/cgroup_namespace.h |  36 ++++++++
>  include/linux/kernfs.h           |   5 +
>  include/linux/nsproxy.h          |   2 +
>  include/linux/proc_ns.h          |   4 +
>  include/uapi/linux/sched.h       |   3 +-
>  kernel/Makefile                  |   2 +-
>  kernel/cgroup.c                  | 108 +++++++++++++++++-----
>  kernel/cgroup_namespace.c        | 148 +++++++++++++++++++++++++++++
>  kernel/fork.c                    |   2 +-
>  kernel/nsproxy.c                 |  19 +++-

Hi Aditya,

Can we provide a documentation file for cgroup namespace behavior. Say,
Documentation/namespaces/cgroup-namespace.txt.

Namespaces are complicated and it might be a good idea to keep one .txt
file for each namespace.

Thanks
Vivek
