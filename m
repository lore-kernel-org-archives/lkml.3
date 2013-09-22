Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3IVRAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:00:11 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:49787 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3IVRAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:00:10 -0400
Date: Sun, 22 Sep 2013 13:00:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, seiji.aguchi@hds.com,
        vgoyal@redhat.com, majianpeng@gmail.com
Subject: Re: [PATCH v2 2/2] elevator: acquire q->sysfs_lock in
 elevator_change()
Message-ID: <20130922170005.GE30946@htj.dyndns.org>
References: <20130830224707.21812.63516.stgit@hds.com>
 <20130830224716.21812.99333.stgit@hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830224716.21812.99333.stgit@hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 06:47:16PM -0400, Tomoki Sekiyama wrote:
> Add locking of q->sysfs_lock into elevator_change() (an exported function)
> to ensure it is held to protect q->elevator from elevator_init(), even if
> elevator_change() is called from non-sysfs paths.
> sysfs path (elv_iosched_store) uses __elevator_change(), non-locking
> version, as the lock is already taken by elv_iosched_store().
> 
> Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@hds.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
