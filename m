Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaAXLS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:18:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbaAXLSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:18:25 -0500
Date: Fri, 24 Jan 2014 11:18:22 +0000
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, compaction: ignore pageblock skip when manually
 invoking compaction
Message-ID: <20140124111822.GS4963@suse.de>
References: <alpine.DEB.2.02.1401222154220.7503@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401222154220.7503@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 09:56:31PM -0800, David Rientjes wrote:
> The cached pageblock hint should be ignored when triggering compaction
> through /proc/sys/vm/compact_memory so all eligible memory is isolated.  
> Manually invoking compaction is known to be expensive, there's no need to
> skip pageblocks based on heuristics (mainly for debugging).
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
