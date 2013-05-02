Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639Ab3EBPWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:22:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760158Ab3EBPWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:22:00 -0400
Date: Thu, 2 May 2013 11:21:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 15/31] blk-throttle: reorganize throtl_service_queue
 passed around as argument
Message-ID: <20130502152148.GF30020@redhat.com>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <1367455189-6957-16-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367455189-6957-16-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 05:39:33PM -0700, Tejun Heo wrote:
> throtl_service_queue will be the building block of hierarchy support
> and will form a tree.  This patch updates its usages as arguments to
> reduce confusion.
> 
> * When a service queue is used as the parent role - the host of the
>   rbtree - use @parent_sq instead of @sq.

Hi Tejun,

Apart from parent_sq, what other kind of sq are present.

Thanks
Vivek
