Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3EQQx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 12:53:26 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:60751 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab3EQQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 12:53:25 -0400
Date: Fri, 17 May 2013 09:53:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: gregkh@linuxfoundation.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cdrom: gdrom: fix device number leak
Message-ID: <20130517165320.GA12632@mtj.dyndns.org>
References: <5195CBE0.6010106@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5195CBE0.6010106@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 02:19:12PM +0800, Libo Chen wrote:
> 
> without this patch, gdrom_major will leak when gd.cd_info alloc faild
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

 Acked-by: Tejun Heo <tj@kernel.org>

This should be routed through the block tree.  Can you please repost
with Jens Axboe <axboe@kernel.dk> added?

Thanks.

-- 
tejun
