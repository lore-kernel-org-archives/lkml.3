Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbbA0Hf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 02:35:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbbA0HfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 02:35:23 -0500
Message-ID: <54C73FB5.30000@suse.cz>
Date: Tue, 27 Jan 2015 08:35:17 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/page_alloc: expands broken freepage to proper
 buddy list when steal
References: <1418022980-4584-1-git-send-email-iamjoonsoo.kim@lge.com> <1418022980-4584-3-git-send-email-iamjoonsoo.kim@lge.com> <54856F88.8090300@suse.cz> <20141210063840.GC13371@js1304-P5Q-DELUXE>
In-Reply-To: <20141210063840.GC13371@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 07:38 AM, Joonsoo Kim wrote:
> After your patch is merged, I will resubmit these on top of it.

Hi Joonsoo,

my page stealing patches are now in -mm so are you planning to resubmit this? At
least patch 1 is an obvious bugfix, and patch 4 a clear compaction overhead
reduction. Those don't need to wait for the rest of the series. If you are busy
with other stuff, I can also resend those two myself if you want.

Thanks,
Vlastimil
