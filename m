Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaFWDFW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 23:05:22 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:33592 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaFWDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 23:05:18 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 23 Jun 2014 12:06:05 +0900
From: Minchan Kim <minchan@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/13] mm, compaction: pass gfp mask to compact_control
Message-ID: <20140623030605.GF12413@bbox>
References: <1403279383-5862-1-git-send-email-vbabka@suse.cz>
 <1403279383-5862-12-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1403279383-5862-12-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 05:49:41PM +0200, Vlastimil Babka wrote:
> From: David Rientjes <rientjes@google.com>
> 
> struct compact_control currently converts the gfp mask to a migratetype, but we
> need the entire gfp mask in a follow-up patch.
> 
> Pass the entire gfp mask as part of struct compact_control.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
