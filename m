Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab3BFW2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:28:03 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:38888 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3BFW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:28:00 -0500
Date: Wed, 6 Feb 2013 14:27:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 21/77] block: fix synchronization and limit check in
 blk_alloc_devt()
Message-ID: <20130206222755.GD2875@htj.dyndns.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-22-git-send-email-tj@kernel.org>
 <20130206142422.b2f8eac6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206142422.b2f8eac6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Wed, Feb 06, 2013 at 02:24:22PM -0800, Andrew Morton wrote:
> This gets all tangled up with
> http://ozlabs.org/~akpm/mmotm/broken-out/block-fix-ext_devt_idr-handling.patch,
> which appears to solve the same issue.
> 
> What to do?

Can you please drop 21 and 22?  Everything else shouldn't be affected
and we can sort these out later.  The actual deprecation patch is held
off for now anyway.

Thanks.

-- 
tejun
