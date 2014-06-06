Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaFFOal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:30:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:57877 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaFFOak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:30:40 -0400
Date: Fri, 6 Jun 2014 16:30:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: regarding use of various cmpxchg* API
Message-ID: <20140606143038.GS13930@laptop.programming.kicks-ass.net>
References: <5390F2D5.909@gatech.edu>
 <20140606072924.GP6758@twins.programming.kicks-ass.net>
 <5391CD70.70703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5391CD70.70703@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 10:17:20AM -0400, Pranith Kumar wrote:
> On 06/06/2014 03:29 AM, Peter Zijlstra wrote:
> 
> > 
> > Don't think that's useful. If you really want to go do something, try
> > the annotation I suggested to get the parisc/sparc32 things correct
> > again. Add the __atomic sparse address space and the store()/load()
> > accessors.
> > 
> 
> OK. I am not sure what you are referring to here, just started looking
> at the kernel again. Any pointers to this accessors thing?

lkml.kernel.org/r/20140603073613.GH11096@twins.programming.kicks-ass.net
