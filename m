Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3KTRYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:24:20 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:63527 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3KTRYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:24:18 -0500
Date: Wed, 20 Nov 2013 12:24:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Hong Zhiguo <honkiko@gmail.com>
Cc: vgoyal@redhat.com, cgroups@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>
Subject: Re: [PATCH] blkcg: have bh disable for 32bit UP system reading 64bit
 stats
Message-ID: <20131120172413.GN28946@htj.dyndns.org>
References: <1383736484-393-1-git-send-email-zhiguohong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383736484-393-1-git-send-email-zhiguohong@tencent.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 07:14:44PM +0800, Hong Zhiguo wrote:
> From: Hong Zhiguo <zhiguohong@tencent.com>
> 
> Update of blkg_stat and blkg_rwstat may happen in bh context.
> While u64_stats_fetch_retry is only preempt_disable on 32bit
> UP system. This is not enough to avoid preemption by bh and
> may read strange 64 bit value.
> 
> Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>

Acked-by: Tejun Heo <tj@kernel.org>

Jens, can you please pick this one up?  This probably needs to be
tagged for stable too.

Thanks!

-- 
tejun
