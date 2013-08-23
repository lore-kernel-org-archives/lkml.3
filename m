Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3HWMeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:34:07 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:54416 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab3HWMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:34:04 -0400
Date: Fri, 23 Aug 2013 08:34:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 11/11] cpuset: export effective masks to userspace
Message-ID: <20130823123400.GB10322@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148FFC.4080701@huawei.com>
 <20130821142001.GK19286@mtj.dyndns.org>
 <52171501.8050401@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52171501.8050401@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 23, 2013 at 03:53:37PM +0800, Li Zefan wrote:
> It seems confusing if there're two interaces but they actually mean
> the same thing.
>
> Another reason I didn't do this is, they're not always the same. When
> !sane, If cpus_allowed is empty, effective_cpus is not empty, and you
> are not able to put tasks into this cpuset. So if we want to  expose
> it unconditionally, I'll make sure cpus_allowed == effective_cpus
> always stand when !sane.

Do you think that'll be convoluted?  Otherwise, sounds like a nice
thing to do anyway.

Thanks.

-- 
tejun
