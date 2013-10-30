Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab3J3PVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:21:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab3J3PVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:21:00 -0400
Date: Wed, 30 Oct 2013 15:20:57 +0000
From: Mel Gorman <mgorman@suse.de>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mm: get rid of unnecessary overhead of
 trace_mm_page_alloc_extfrag()
Message-ID: <20131030152057.GP2400@suse.de>
References: <1382719367-11537-1-git-send-email-kosaki.motohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1382719367-11537-1-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 12:42:47PM -0400, kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> In general, every tracepoint should be zero overhead if it is disabled.
> However, trace_mm_page_alloc_extfrag() is one of exception. It evaluate
> "new_type == start_migratetype" even if tracepoint is disabled.
> 
> However, the code can be moved into tracepoint's TP_fast_assign() and
> TP_fast_assign exist exactly such purpose. This patch does it.
> 
> Cc: Mel Gorman <mgorman@suse.de>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
