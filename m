Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3CSUt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:49:27 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:48553 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab3CSUtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:49:24 -0400
Date: Tue, 19 Mar 2013 13:49:19 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com
Subject: Re: [PATCHSET wq/for-3.10] workqueue: simplify per-cpu worker
 rebinding and implement unbound worker CPU affinity restoration
Message-ID: <20130319204919.GK3042@htj.dyndns.org>
References: <1363302090-16117-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363302090-16117-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 04:01:25PM -0700, Tejun Heo wrote:
>  0001-sched-replace-PF_THREAD_BOUND-with-PF_NO_SETAFFINITY.patch
>  0002-workqueue-convert-worker_pool-worker_ida-to-idr-and-.patch
>  0003-workqueue-relocate-rebind_workers.patch
>  0004-workqueue-directly-restore-CPU-affinity-of-workers-f.patch
>  0005-workqueue-restore-CPU-affinity-of-unbound-workers-on.patch

Applied to wq/for-3.10.

Thanks.

-- 
tejun
