Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbaEERsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:48:13 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:52825 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaEERsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:48:11 -0400
Date: Mon, 5 May 2014 13:48:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Li Zefan <lizefan@huawei.com>, axboe@kernel.dk,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.15-fixes] blkcg: use trylock on
 blkcg_pol_mutex in blkcg_reset_stats()
Message-ID: <20140505174807.GO11231@htj.dyndns.org>
References: <5363C04B.4010400@oracle.com>
 <20140505163730.GL11231@htj.dyndns.org>
 <5367CE9E.5010208@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5367CE9E.5010208@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 01:47:10PM -0400, Sasha Levin wrote:
> Hey Tejun,
> 
> On 05/05/2014 12:37 PM, Tejun Heo wrote:
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Li Zefan <lizefan@huawei.com>
> > References: http://lkml.kernel.org/g/5363C04B.4010400@oracle.com
> 
> I think that the Reported-by here should be me :)

Oops, how did that happen?  :)

Fixing up in the branch.

Thanks!

-- 
tejun
