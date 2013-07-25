Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab3GYXaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:30:13 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53579 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GYXaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:30:08 -0400
X-AuditID: 9c93016f-b7b50ae0000021a9-c5-51f1b4fee47e
Date: Fri, 26 Jul 2013 08:30:13 +0900
From: Minchan Kim <minchan@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Szabo <psz@maths.usyd.edu.au>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] Revert "page-writeback.c: subtract min_free_kbytes from
 dirtyable memory"
Message-ID: <20130725233013.GC27252@bbox>
References: <1374793134-16678-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374793134-16678-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 06:58:54PM -0400, Johannes Weiner wrote:
> This reverts commit 75f7ad8e043d9383337d917584297f7737154bbf.  It was
> the result of a problem observed with a 3.2 kernel and merged in 3.9,
> while the issue had been resolved upstream in 3.3 (ab8fabd mm: exclude
> reserved pages from dirtyable memory).
> 
> The "reserved pages" are a superset of min_free_kbytes, thus this
> change is redundant and confusing.  Revert it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Absolutely true and I pointed it out at that time but ignored and merged. :(
http://lists.debian.org/debian-kernel/2013/01/msg00538.html
Even, not Cced so I couldn't notice it until you send out this patch.

Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
