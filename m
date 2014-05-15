Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbaEOUv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:51:26 -0400
Received: from one.firstfloor.org ([193.170.194.197]:36397 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaEOUvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:51:25 -0400
Date: Thu, 15 May 2014 22:51:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 9/9] perf, tools, record: Always allow to overide
 default period v2
Message-ID: <20140515205123.GF1873@two.firstfloor.org>
References: <1399935074-25167-1-git-send-email-andi@firstfloor.org>
 <1399935074-25167-10-git-send-email-andi@firstfloor.org>
 <87r43wlxhk.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r43wlxhk.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 02:50:47PM +0900, Namhyung Kim wrote:
> On Mon, 12 May 2014 15:51:14 -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > Fix the logic to allow overriding event default periods with -c or -F
> > on the command line.  I'm not sure I understand this if() fully, but
> > this change makes all cases I tested work (tracepoint with default, default,
> > ,-c, -F)
> >
> > This fixed specifying -c / -F with json event list events,
> > which have a default period. It should do the same
> > for trace point events.
> 
> Hmm.. doesn't that require both -c and -F are given at the same time?

I don't think so.

> 
> Anyway, there was a similar discussion, but I suggested an other way.
> Please see the line below.

I had tried a couple of combinations earlier, this was the one that
worked in all cases.

-Andi
