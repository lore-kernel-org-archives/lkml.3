Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab3EBR3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:29:33 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:49674 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761084Ab3EBR31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:29:27 -0400
Date: Thu, 2 May 2013 10:29:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 15/31] blk-throttle: reorganize throtl_service_queue
 passed around as argument
Message-ID: <20130502172922.GJ19814@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <1367455189-6957-16-git-send-email-tj@kernel.org>
 <20130502152148.GF30020@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502152148.GF30020@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 11:21:48AM -0400, Vivek Goyal wrote:
> On Wed, May 01, 2013 at 05:39:33PM -0700, Tejun Heo wrote:
> > throtl_service_queue will be the building block of hierarchy support
> > and will form a tree.  This patch updates its usages as arguments to
> > reduce confusion.
> > 
> > * When a service queue is used as the parent role - the host of the
> >   rbtree - use @parent_sq instead of @sq.
> 
> Hi Tejun,
> 
> Apart from parent_sq, what other kind of sq are present.

Just sq and parent_sq where the former is used when it isn't
particularly about being the parent or used as the child variable.

Thanks.

-- 
tejun
