Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3GWFwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 01:52:51 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50767 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3GWFwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 01:52:50 -0400
Date: Tue, 23 Jul 2013 01:52:41 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: kill one if in loop of __free_pages_bootmem
Message-ID: <20130723055241.GI715@cmpxchg.org>
References: <1374545862-17741-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374545862-17741-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 07:17:42PM -0700, Yinghai Lu wrote:
> We should not check loop+1 with loop end in loop body.
> Just duplicate two lines code to avoid it.
> 
> That will help a bit when we have huge amount of pages on
> system with 16TiB memory.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>

Disassembly looks good, thanks!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
