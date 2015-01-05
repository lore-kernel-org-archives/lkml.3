Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbbAECdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 21:33:55 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57895 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbbAECdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 21:33:54 -0500
X-Original-SENDERIP: 10.177.220.158
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 5 Jan 2015 11:33:52 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/compaction: enhance trace output to know more
 about compaction internals
Message-ID: <20150105023352.GB3534@js1304-P5Q-DELUXE>
References: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 04:52:05PM +0900, Joonsoo Kim wrote:
> It'd be useful to know where the both scanner is start. And, it also be
> useful to know current range where compaction work. It will help to find
> odd behaviour or problem on compaction.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Hello, Andrew and Vlastimil.

Could you review or merge this patchset?
It would help to trace compaction behaviour.

Thanks.
