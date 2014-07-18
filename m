Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965586AbaGROzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:55:14 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:58320 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965423AbaGROzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:55:12 -0400
Date: Fri, 18 Jul 2014 15:55:07 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 7/8] arm64: add pmd_[dirty|mkclean] for THP
Message-ID: <20140718145506.GB18569@linaro.org>
References: <1405666386-15095-1-git-send-email-minchan@kernel.org>
 <1405666386-15095-8-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405666386-15095-8-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 03:53:05PM +0900, Minchan Kim wrote:
> MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
> overwrite of the contents since MADV_FREE syscall is called for
> THP page.
> 
> This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
> support.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Steve Capper <steve.capper@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Steve Capper <steve.capper@linaro.org> 
