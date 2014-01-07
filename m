Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaAGPXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:23:43 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:38358 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaAGPXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:23:32 -0500
Date: Tue, 7 Jan 2014 10:23:28 -0500
From: Tejun Heo <tj@kernel.org>
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, jiang.liu@huawei.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, tangchen@cn.fujitsu.com,
        toshi.kani@hp.com
Subject: Re: [PATCH 2/2] mm: free memblock.memory in free_all_bootmem
Message-ID: <20140107152328.GB3231@htj.dyndns.org>
References: <1389107774-54978-1-git-send-email-phacht@linux.vnet.ibm.com>
 <1389107774-54978-3-git-send-email-phacht@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389107774-54978-3-git-send-email-phacht@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 04:16:14PM +0100, Philipp Hachtmann wrote:
> When calling free_all_bootmem() the free areas under memblock's
> control are released to the buddy allocator. Additionally the
> reserved list is freed if it was reallocated by memblock.
> The same should apply for the memory list.
> 
> Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
