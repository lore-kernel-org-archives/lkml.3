Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3LMVVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 16:21:39 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:53259 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3LMVVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 16:21:38 -0500
Date: Fri, 13 Dec 2013 16:21:34 -0500
From: Tejun Heo <tj@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 05/23] mm/memblock: drop WARN and use SMP_CACHE_BYTES
 as a default alignment
Message-ID: <20131213212134.GJ27070@htj.dyndns.org>
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com>
 <1386625856-12942-6-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386625856-12942-6-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 04:50:38PM -0500, Santosh Shilimkar wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Don't produce warning and interpret 0 as "default align" equal to
> SMP_CACHE_BYTES in case if caller of memblock_alloc_base_nid() doesn't
> specify alignment for the block (align == 0).
> 
> This is done in preparation of introducing common memblock alloc
> interface to make code behavior consistent. More details are
> in below thread :
> 	https://lkml.org/lkml/2013/10/13/117.
> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
