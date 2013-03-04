Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab3CDRib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:38:31 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64401 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3CDRi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:38:29 -0500
Date: Mon, 4 Mar 2013 09:38:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Message-ID: <20130304173825.GC30413@htj.dyndns.org>
References: <512C8D84.7090707@huawei.com>
 <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
 <512DE4A8.5050303@huawei.com>
 <CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com>
 <512EFEDF.8080205@huawei.com>
 <CAOS58YMBcvhfBWdQmt=JersRgB9nVgsrLACtLovz===2ZXfR=w@mail.gmail.com>
 <51304C6D.8050207@huawei.com>
 <20130301203917.GT4503@ZenIV.linux.org.uk>
 <CAOS58YPNAPhWUwNq9G39Airo+TvV2ecXBiNU5s9PFqkL3RbRFg@mail.gmail.com>
 <51340ECD.1030905@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51340ECD.1030905@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 04, 2013 at 11:02:37AM +0800, Li Zefan wrote:
> > Yeah, that's what I meant by the "anal" part although it seems like
> > c99 doesn't even allow that. Do we care tho? It seems like a logical
> > feature which should show up in the standard eventually. Maybe it
> > could be a problem for clang?
> > 
> 
> Do we have a decision now? Please pick v4 if this GNU extension can't be used
> in kernel code, otherwise v5.

I'm just gonna apply the one with the initializer.  It's simpler and
not like we can't back out easily if it ever becomes a problem.

Thanks.

-- 
tejun
