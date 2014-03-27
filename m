Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbaC0O5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 10:57:49 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:59579 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbaC0O5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 10:57:47 -0400
Date: Thu, 27 Mar 2014 10:57:43 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/percpu.c: renew the max_contig if we merge the
 head and previous block.
Message-ID: <20140327145743.GC18503@htj.dyndns.org>
References: <1395918343-6775-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395918343-6775-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 07:05:43PM +0800, Jianyu Zhan wrote:
> During pcpu_alloc_area(), we might merge the current head with the
> previous block. Since we have calculated the max_contig using the
> size of previous block before we skip it, and now we update the size
> of previous block, so we should renew the max_contig.

pcpu_alloc_area() has been reimplemented in percpu/for-3.15.  Can you
please refresh the patch against the new implementation?

Thanks.

-- 
tejun
