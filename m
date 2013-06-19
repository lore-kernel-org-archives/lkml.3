Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3FSIXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:23:53 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60581 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab3FSIXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:23:50 -0400
Date: Wed, 19 Jun 2013 01:23:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH ] cgroup: rename cont to cgrp
Message-ID: <20130619082347.GE30681@mtj.dyndns.org>
References: <51BA8B3F.3060606@huawei.com>
 <51C109DE.8010607@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C109DE.8010607@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 09:31:10AM +0800, Li Zefan wrote:
> Hi Tejun,
> 
> Could you apply this patch?

Oops, I thought I applied this one.  Apparently not.

> On 2013/6/14 11:17, Li Zefan wrote:
> > Cont is short for container. control group was named process container
> > at first, but then people found container already has a meaning in
> > linux kernel.
> > 
> > Clean up the leftover variable name @cont.
> > 
> > Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.11.

Thanks.

-- 
tejun
