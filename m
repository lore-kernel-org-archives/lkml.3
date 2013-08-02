Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3HBTgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:36:03 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:43639 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab3HBTgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:36:01 -0400
Date: Fri, 2 Aug 2013 15:35:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/23] cgroup: relocate cgroup_advance_iter()
Message-ID: <20130802193556.GB29736@mtj.dyndns.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-17-git-send-email-tj@kernel.org>
 <51FB26C6.2020100@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FB26C6.2020100@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Fri, Aug 02, 2013 at 11:25:58AM +0800, Li Zefan wrote:
> On 2013/8/2 5:49, Tejun Heo wrote:
> > For some reason, cgroup_advance_iter() is standing lonely all away
> > from its iter comrades.  Relocate it.
> > 
> 
> There're some other functions that are in the same situation. Do you
> think it's better to relocate them, or just leave it as it is?

Hmm... I really don't wanna do one huge reorganize-everything patch as
they tend to be difficult to verify and the disturbance to benefit
ration usually isn't that high, but if the respective part of code is
going through changes and thus will be disturbed anyway, I think it
makes sense to reorganize a bit.

Thanks.

-- 
tejun
