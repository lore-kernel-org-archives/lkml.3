Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997AbaENSho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:37:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:51683 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaENShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:37:43 -0400
Date: Wed, 14 May 2014 20:37:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: perf: use after free in perf_remove_from_context
Message-ID: <20140514183739.GM2485@laptop.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
 <20140514162943.GR30445@twins.programming.kicks-ass.net>
 <53739A9A.5010703@oracle.com>
 <20140514163535.GS30445@twins.programming.kicks-ass.net>
 <53739BF2.1030100@oracle.com>
 <20140514165205.GU30445@twins.programming.kicks-ass.net>
 <5373A34B.1010008@oracle.com>
 <20140514172043.GA31281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514172043.GA31281@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 01:20:43PM -0400, Dave Jones wrote:
> Pretty strong odds it's mremap causing those double frees.  You can
> -xmremap that to see if it goes away.

unless I'm entirely pebkac atm it doesn't seem to help any.
