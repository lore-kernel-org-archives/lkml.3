Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaBYKUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:20:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36812 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBYKU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:20:28 -0500
Date: Tue, 25 Feb 2014 11:20:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/11] perf core: export swevent hrtimer helpers
Message-ID: <20140225102008.GI9987@twins.programming.kicks-ass.net>
References: <1392415338-16288-3-git-send-email-cody@linux.vnet.ibm.com>
 <20140225033326.7BB942C0228@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225033326.7BB942C0228@ozlabs.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 02:33:26PM +1100, Michael Ellerman wrote:
> On Fri, 2014-14-02 at 22:02:06 UTC, Cody P Schafer wrote:
> > Export the swevent hrtimer helpers currently only used in events/core.c
> > to allow the addition of architecture specific sw-like pmus.
> 
> Peter, Ingo, can we get your ACK on this please?

How are they used? I saw some usage in patch 9 or so; but its not
explained anywhere. All patches have non-existent Changelogs and the few
comments that are there are pretty hardware specific.

So please do tell; what do you need this for?


