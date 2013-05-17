Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3EQUuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 16:50:04 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:45210 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709Ab3EQUuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 16:50:02 -0400
Date: Fri, 17 May 2013 16:49:51 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Alexey Lyahkov <alexey.lyashkov@gmail.com>,
        Andrew Perepechko <anserper@ya.ru>, Robin Dong <sanbai@taobao.com>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Bernd Schubert <bernd.schubert@fastmail.fm>,
        David Howells <dhowells@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-ext4 <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] mm: Remove lru parameter from __lru_cache_add and
 lru_cache_add_lru
Message-ID: <20130517204951.GD15721@cmpxchg.org>
References: <1368784087-956-1-git-send-email-mgorman@suse.de>
 <1368784087-956-6-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368784087-956-6-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:48:07AM +0100, Mel Gorman wrote:
> Similar to __pagevec_lru_add, this patch removes the LRU parameter
> from __lru_cache_add and lru_cache_add_lru as the caller does not
> control the exact LRU the page gets added to. lru_cache_add_lru gets
> renamed to lru_cache_add the name is silly without the lru parameter.
> With the parameter removed, it is required that the caller indicate
> if they want the page added to the active or inactive list by setting
> or clearing PageActive respectively.
> 
> [akpm@linux-foundation.org: Suggested the patch]
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
