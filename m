Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbbAEI6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:58:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbbAEI6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:58:11 -0500
Message-ID: <54AA5220.5080205@suse.cz>
Date: Mon, 05 Jan 2015 09:58:08 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/compaction: enhance trace output to know more
 about compaction internals
References: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com> <20150105023352.GB3534@js1304-P5Q-DELUXE>
In-Reply-To: <20150105023352.GB3534@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 03:33 AM, Joonsoo Kim wrote:
> On Wed, Dec 03, 2014 at 04:52:05PM +0900, Joonsoo Kim wrote:
>> It'd be useful to know where the both scanner is start. And, it also be
>> useful to know current range where compaction work. It will help to find
>> odd behaviour or problem on compaction.
>> 
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Hello, Andrew and Vlastimil.
> 
> Could you review or merge this patchset?

I hope to review it soon, just "recovering" from a vacation ;-)

> It would help to trace compaction behaviour.

Yep,
Thanks

> Thanks.
> 

