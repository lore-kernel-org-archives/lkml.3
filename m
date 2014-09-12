Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaILHhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 03:37:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56863 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaILHhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:37:33 -0400
Date: Fri, 12 Sep 2014 09:37:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: paulmck@linux.vnet.ibm.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dbueso@suse.de
Subject: Re: [PATCH 8/9] locktorture: Support rwsems
Message-ID: <20140912073729.GK346@worktop.programming.kicks-ass.net>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
 <1410496890.2166.11.camel@linux-t7sj.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410496890.2166.11.camel@linux-t7sj.site>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 09:41:30PM -0700, Davidlohr Bueso wrote:
> We can easily do so with our new reader lock support. Just an arbitrary
> design default: readers have higher (5x) critical region latencies than
> writers: 50 ms and 10 ms, respectively.
> 

Nice, could you copy/paste this into a rwlock test as well?
