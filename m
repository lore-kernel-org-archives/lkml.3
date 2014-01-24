Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaAXK2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:28:05 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46352 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaAXK2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:28:03 -0500
Date: Fri, 24 Jan 2014 05:27:58 -0500
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
Message-ID: <20140124102758.GA4101@htj.dyndns.org>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org>
 <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com>
 <52E1C8BD.2010500@huawei.com>
 <CAKohpomn_wgQExfhJL6=MB9LrRhR4=+7t3ehy0d6vEq9duzr8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomn_wgQExfhJL6=MB9LrRhR4=+7t3ehy0d6vEq9duzr8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 10:27:34AM +0530, Viresh Kumar wrote:
> On 24 January 2014 07:28, Li Zefan <lizefan@huawei.com> wrote:
> >> Acked-by: David Rientjes <rientjes@google.com>
> >
> > Acked-by: Li Zefan <lizefan@huawei.com>
> 
> Thanks..
> 
> > I would like this patch be picked up by Tejun. I'll send out a patchset
> > for cpuset which may have confliction with this one.
> 
> Its already applied by Andrew Morton..

Ummm... so, the original posting forgot to cc Li (the maintainer), me
or cgroups mailing list.  Please don't do this in the future.

Thanks.

-- 
tejun
