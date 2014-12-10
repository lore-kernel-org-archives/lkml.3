Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbaLJGcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:32:36 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60957 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaLJGcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:32:35 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 10 Dec 2014 15:36:28 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] enhance compaction success rate
Message-ID: <20141210063628.GB13371@js1304-P5Q-DELUXE>
References: <1418022980-4584-1-git-send-email-iamjoonsoo.kim@lge.com>
 <54856C72.4040705@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54856C72.4040705@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 10:16:34AM +0100, Vlastimil Babka wrote:
> On 12/08/2014 08:16 AM, Joonsoo Kim wrote:
> >This patchset aims at increase of compaction success rate. Changes are
> >related to compaction finish condition and freepage isolation condition.
> >
> > From these changes, I did stress highalloc test in mmtests with nonmovable
> >order 7 allocation configuration, and success rate (%) at phase 1 are,
> >
> >Base	Patch-1	Patch-3	Patch-4
> >55.00	57.00	62.67	64.00
> >
> >And, compaction success rate (%) on same test are,
> >
> >Base	Patch-1	Patch-3	Patch-4
> >18.47	28.94	35.13	41.50
> 
> Did you test Patch-2 separately? Any difference to Patch 1?

I didn't test it separately. I guess that there is no remarkable
difference because it just slightly changes page stealing logic, not
compaction logic. Compaction success rate would not be affected by
patch 2, but, I will check it next time.

Thanks.
