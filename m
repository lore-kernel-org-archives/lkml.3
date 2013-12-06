Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab3LFIy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:54:57 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62664 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab3LFIyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:54:52 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-a2-52a190dab543
Date: Fri, 6 Dec 2013 17:57:30 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        azurIt <azurit@pobox.sk>,
        Linux Memory Management List <linux-mm@kvack.org>,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christian Casteyde <casteyde.christian@free.fr>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [patch 2/2] fs: buffer: move allocation failure loop into the
 allocator
Message-ID: <20131206085730.GB24706@lge.com>
References: <1381265890-11333-1-git-send-email-hannes@cmpxchg.org>
 <1381265890-11333-2-git-send-email-hannes@cmpxchg.org>
 <20131203165910.54d6b4724a1f3e329af52ac6@linux-foundation.org>
 <20131204015218.GA19709@lge.com>
 <20131203180717.94c013d1.akpm@linux-foundation.org>
 <00000142be2f1de0-764bb035-adbc-4367-b2b4-bf05498510a6-000000@email.amazonses.com>
 <CAAmzW4PwLhMd61ksOktdg=rkj0xHsSGt2Wm_za2Adjh4+tss-g@mail.gmail.com>
 <00000142be753b07-aa0e2354-6704-41f8-8e11-3c856a186af5-000000@email.amazonses.com>
 <20131205084441.GA5561@lge.com>
 <00000142c4192155-e27322df-ba1a-4af8-98c3-f2b15dd70d13-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142c4192155-e27322df-ba1a-4af8-98c3-f2b15dd70d13-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 06:50:50PM +0000, Christoph Lameter wrote:
> On Thu, 5 Dec 2013, Joonsoo Kim wrote:
> 
> > I could try. But my trial would not figure this out, since my machine has
> > just 4 cores which normally cannot produce heavy contention.
> 
> I think that is fine for starters. Once we know what to look for we can
> find machines to test specific scenarios.
> 
> > Anyway, could you tell me where I can find your synthetic benchmarks for slab?
> 
> https://lkml.org/lkml/2009/10/13/459

Okay.
Thanks.
