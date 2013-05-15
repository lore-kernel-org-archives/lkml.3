Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab3EORqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:46:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759767Ab3EORqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:46:19 -0400
Message-ID: <5193C9DA.8030504@redhat.com>
Date: Wed, 15 May 2013 13:46:02 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Alexey Lyahkov <alexey.lyashkov@gmail.com>,
        Andrew Perepechko <anserper@ya.ru>, Robin Dong <sanbai@taobao.com>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Bernd Schubert <bernd.schubert@fastmail.fm>,
        David Howells <dhowells@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-ext4 <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 4/4] mm: Remove lru parameter from __pagevec_lru_add and
 remove parts of pagevec API
References: <1368440482-27909-1-git-send-email-mgorman@suse.de> <1368440482-27909-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1368440482-27909-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 06:21 AM, Mel Gorman wrote:
> Now that the LRU to add a page to is decided at LRU-add time, remove the
> misleading lru parameter from __pagevec_lru_add. A consequence of this is
> that the pagevec_lru_add_file, pagevec_lru_add_anon and similar helpers
> are misleading as the caller no longer has direct control over what LRU
> the page is added to. Unused helpers are removed by this patch and existing
> users of pagevec_lru_add_file() are converted to use lru_cache_add_file()
> directly and use the per-cpu pagevecs instead of creating their own pagevec.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Jan Kara <jack@suse.cz>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
