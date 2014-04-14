Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaDNRwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:52:43 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:63447 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaDNRwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:52:40 -0400
Date: Mon, 14 Apr 2014 13:52:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
Message-ID: <20140414175236.GB15249@htj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
 <20140414154556.GA9552@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414154556.GA9552@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 14, 2014 at 11:45:56AM -0400, Vivek Goyal wrote:
> So this patchset does not *enforce* a single hierarchy? So user space
> can still mount other hierarchies.

Nope, nothing is forced.  Controllers may be moved between unified and
traditional multiple hierarchies.

> How does this work for root's tasks now? Given that task can only be
> in leaf cgroups, that means tasks can't be in / cgroup (If one wants
> to create some cgroups). Does that mean / will be empty and init system
> need to setup things right.

Root is exempt from the restriction.  Root has always been special
anyway.

I'll soon post a document describing the design and restrictions of
unified hierarchy along with an updated version of this patchset.

Thanks.

-- 
tejun
