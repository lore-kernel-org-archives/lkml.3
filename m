Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaGDRPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:15:48 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:38418 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaGDRPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:15:47 -0400
Date: Fri, 4 Jul 2014 13:15:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: blk: NULL ptr deref in blk_throtl_drain
Message-ID: <20140704171544.GB11787@mtj.dyndns.org>
References: <53B6DA3E.40704@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B6DA3E.40704@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 12:45:50PM -0400, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:
> 
> [ 3660.610281] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> [ 3660.612608] IP: blk_throtl_drain (block/blk-throttle.c:1639)

This is a problem which can also happen before the patch with lower
frequency.  There was a fix proposed about a week ago which I
suggested a different approach for.  I'll dig up that thread and ping.

Thanks.

-- 
tejun
