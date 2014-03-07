Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaCGNGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:06:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaCGNGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:06:51 -0500
Message-ID: <5319BB3A.6020102@redhat.com>
Date: Fri, 07 Mar 2014 07:27:38 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, compaction: determine isolation mode only once
References: <alpine.DEB.2.02.1403070358120.13046@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1403070358120.13046@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 07:01 AM, David Rientjes wrote:
> The conditions that control the isolation mode in 
> isolate_migratepages_range() do not change during the iteration, so 
> extract them out and only define the value once.
> 
> This actually does have an effect, gcc doesn't optimize it itself because 
> of cc->sync.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
