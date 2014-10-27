Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaJ0HxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:53:13 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:39585 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJ0HxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:53:12 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 27 Oct 2014 16:54:26 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com
Subject: Re: [RFC 0/4] [RFC] slub: Fastpath optimization (especially for RT)
Message-ID: <20141027075426.GE23379@js1304-P5Q-DELUXE>
References: <20141022155517.560385718@linux.com>
 <20141023080942.GA7598@js1304-P5Q-DELUXE>
 <alpine.DEB.2.11.1410230916090.19494@gentwo.org>
 <20141024045630.GD15243@js1304-P5Q-DELUXE>
 <alpine.DEB.2.11.1410240901020.26767@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410240901020.26767@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 09:02:18AM -0500, Christoph Lameter wrote:
> On Fri, 24 Oct 2014, Joonsoo Kim wrote:
> 
> > In this case, object from cpu1's cpu_cache should be
> > different with cpu0's, so allocation would be failed.
> 
> That is true for most object pointers unless the value is NULL. Which it
> can be. But if this is the only case then the second patch + your approach
> would work too.

Indeed... I missed the null value case.
Your second patch + mine would fix that situation, but, I need more
thinking. :)

Thanks.
