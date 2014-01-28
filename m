Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaA1Gdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:33:50 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:63811 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbaA1Gds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:33:48 -0500
Date: Mon, 27 Jan 2014 22:33:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Li Zefan <lizefan@huawei.com>
cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cpuset: update MAINTAINERS entry
In-Reply-To: <52E72405.7070402@huawei.com>
Message-ID: <alpine.DEB.2.02.1401272232150.17436@chino.kir.corp.google.com>
References: <52E72405.7070402@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Li Zefan wrote:

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8285ed4..81bcbe0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2376,8 +2376,10 @@ F:	tools/power/cpupower/
>  
>  CPUSETS
>  M:	Li Zefan <lizefan@huawei.com>
> +L:	cgroups@vger.kernel.org
>  W:	http://www.bullopensource.org/cpuset/
>  W:	http://oss.sgi.com/projects/cpusets/
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
>  S:	Maintained
>  F:	Documentation/cgroups/cpusets.txt
>  F:	include/linux/cpuset.h

It seems like Tejun would obviously be a maintainer as well?
