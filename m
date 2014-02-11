Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaBKHVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:21:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45580 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKHVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:21:08 -0500
Date: Tue, 11 Feb 2014 08:20:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: linux-kernel@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 3/8] mutex: Modify the way optimistic spinners are queued
Message-ID: <20140211072049.GI27965@twins.programming.kicks-ass.net>
References: <20140210195820.834693028@infradead.org>
 <20140210203659.532019477@infradead.org>
 <1392082398.2918.33.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392082398.2918.33.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 05:33:18PM -0800, Jason Low wrote:

> > +	mcs_spin_lock(&lock->mcs_lock);
> 
> Where did the mcs node go? :)

Bugger, that's what I get for not compiling each patch in the series..
:-/
