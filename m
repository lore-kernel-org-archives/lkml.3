Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbbALIUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:20:36 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52973 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbbALIUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:20:35 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 12 Jan 2015 17:20:57 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/compaction: enhance trace output to know more
 about compaction internals
Message-ID: <20150112082057.GA26078@js1304-P5Q-DELUXE>
References: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com>
 <54ABA563.1040103@suse.cz>
 <20150108081835.GC25453@js1304-P5Q-DELUXE>
 <54AE43E3.60209@suse.cz>
 <20150109105710.GN2395@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109105710.GN2395@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 10:57:10AM +0000, Mel Gorman wrote:
> On Thu, Jan 08, 2015 at 09:46:27AM +0100, Vlastimil Babka wrote:
> > On 01/08/2015 09:18 AM, Joonsoo Kim wrote:
> > > On Tue, Jan 06, 2015 at 10:05:39AM +0100, Vlastimil Babka wrote:
> > >> On 12/03/2014 08:52 AM, Joonsoo Kim wrote:
> > >> > It'd be useful to know where the both scanner is start. And, it also be
> > >> > useful to know current range where compaction work. It will help to find
> > >> > odd behaviour or problem on compaction.
> > >> 
> > >> Overall it looks good, just two questions:
> > >> 1) Why change the pfn output to hexadecimal with different printf layout and
> > >> change the variable names and? Is it that better to warrant people having to
> > >> potentially modify their scripts parsing the old output?
> > > 
> > > Deciaml output has really bad readability since we manage all pages by order
> > > of 2 which is well represented by hexadecimal. With hex output, we can
> > > easily notice whether we move out from one pageblock to another one.
> > 
> > OK. I don't have any strong objection, maybe Mel should comment on this as the
> > author of most of the tracepoints? But if it happens, I think converting the old
> > tracepoints to new hexadecimal format should be a separate patch from adding the
> > new ones.
> > 
> 
> To date, I'm not aware of any user-space programs that heavily depend on
> the formatting. The scripts I am aware of are ad-hoc and easily modified
> to adapt to format changes. LTT-NG is the only tool that might be
> depending on trace point formats but I severely doubt it's interested in
> this particular tracepoint.

Okay. Thanks for confirmation!

Thanks.
