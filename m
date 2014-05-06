Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaEFRYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:24:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbaEFRYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:24:38 -0400
Message-ID: <53691AC9.8070104@redhat.com>
Date: Tue, 06 May 2014 13:24:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/17] mm: page_alloc: Only check the alloc flags and
 gfp_mask for dirty once
References: <1398933888-4940-1-git-send-email-mgorman@suse.de> <1398933888-4940-7-git-send-email-mgorman@suse.de>
In-Reply-To: <1398933888-4940-7-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 04:44 AM, Mel Gorman wrote:
> Currently it's calculated once per zone in the zonelist.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
