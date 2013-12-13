Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3LMVWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 16:22:34 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:39797 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3LMVWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 16:22:33 -0500
Date: Fri, 13 Dec 2013 16:22:29 -0500
From: Tejun Heo <tj@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 06/23] mm/memblock: reorder parameters of
 memblock_find_in_range_node
Message-ID: <20131213212229.GK27070@htj.dyndns.org>
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com>
 <1386625856-12942-7-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386625856-12942-7-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 04:50:39PM -0500, Santosh Shilimkar wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Reorder parameters of memblock_find_in_range_node to be consistent
> with other memblock APIs.
> 
> The change was suggested by Tejun Heo <tj@kernel.org>.
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
