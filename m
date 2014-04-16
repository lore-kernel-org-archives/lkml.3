Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbaDPSc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:32:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbaDPScz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:32:55 -0400
Message-ID: <534EA699.6040105@redhat.com>
Date: Wed, 16 Apr 2014 11:49:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heesub Shin <heesub.shin@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dongjun Shin <d.j.shin@samsung.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] mm/compaction: cleanup isolate_freepages()
References: <5342BA34.8050006@suse.cz> <1397553507-15330-1-git-send-email-vbabka@suse.cz> <1397553507-15330-2-git-send-email-vbabka@suse.cz>
In-Reply-To: <1397553507-15330-2-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 05:18 AM, Vlastimil Babka wrote:
> isolate_freepages() is currently somewhat hard to follow thanks to many
> different pfn variables. Especially misleading is the name 'high_pfn' which
> looks like it is related to the 'low_pfn' variable, but in fact it is not.
>
> This patch renames the 'high_pfn' variable to a hopefully less confusing name,
> and slightly changes its handling without a functional change. A comment made
> obsolete by recent changes is also updated.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

