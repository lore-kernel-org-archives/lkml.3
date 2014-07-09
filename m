Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaGILPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:15:06 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:12319 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753276AbaGILPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:15:01 -0400
Date: Wed, 9 Jul 2014 12:14:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Will Deacon <Will.Deacon@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v12 7/8] arm64: add pmd_[dirty|mkclean] for THP
Message-ID: <20140709111446.GE27270@arm.com>
References: <1404886949-17695-1-git-send-email-minchan@kernel.org>
 <1404886949-17695-8-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404886949-17695-8-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 07:22:28AM +0100, Minchan Kim wrote:
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
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
