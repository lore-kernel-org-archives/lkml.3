Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaAGPTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:19:55 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:48947 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaAGPTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:19:46 -0500
Date: Tue, 7 Jan 2014 10:19:42 -0500
From: Tejun Heo <tj@kernel.org>
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, jiang.liu@huawei.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, tangchen@cn.fujitsu.com,
        toshi.kani@hp.com
Subject: Re: [PATCH 1/2] mm, nobootmem: Add return value check in
 __alloc_memory_core_early()
Message-ID: <20140107151942.GA3231@htj.dyndns.org>
References: <1389107774-54978-1-git-send-email-phacht@linux.vnet.ibm.com>
 <1389107774-54978-2-git-send-email-phacht@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389107774-54978-2-git-send-email-phacht@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 04:16:13PM +0100, Philipp Hachtmann wrote:
> When memblock_reserve() fails because memblock.reserved.regions cannot
> be resized, the caller (e.g. alloc_bootmem()) is not informed of the
> failed allocation. Therefore alloc_bootmem() silently returns the same
> pointer again and again.
> This patch adds a check for the return value of memblock_reserve() in
> __alloc_memory_core().
> 
> Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
