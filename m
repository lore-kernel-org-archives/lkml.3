Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaEVEaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:30:08 -0400
Received: from ozlabs.org ([103.22.144.67]:58354 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaEVEaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:30:06 -0400
Message-ID: <1400733004.14864.9.camel@concordia>
Subject: Re: Fwd: [V6 00/11] perf: New conditional branch filter
From: Michael Ellerman <mpe@ellerman.id.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 22 May 2014 14:30:04 +1000
In-Reply-To: <20140521120146.GD2485@laptop.programming.kicks-ass.net>
References: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
	 <537C6DDE.9000204@linux.vnet.ibm.com>
	 <20140521092313.GF30445@twins.programming.kicks-ass.net>
	 <537C827B.9090505@linux.vnet.ibm.com>
	 <20140521120146.GD2485@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 14:01 +0200, Peter Zijlstra wrote:
> On Wed, May 21, 2014 at 04:09:55PM +0530, Anshuman Khandual wrote:
> > On 05/21/2014 02:53 PM, Peter Zijlstra wrote:
> > > On Wed, May 21, 2014 at 02:41:58PM +0530, Anshuman Khandual wrote:
> > >> Hello Peter/Ingo,
> > >>
> > >> Would you please consider reviewing the first four patches in this patch series
> > >> which changes the generic perf kernel and perf tools code. Andi Kleen and Stephane
> > >> Eranian have already reviewed these changes. The rest of the patch series is related
> > >> to powerpc and being reviewed by Michael Ellerman/Ben.
> > >>
> > > 
> > > If they land in my inbox I might have a look.
> > > 
> > 
> > Sent.
> 
> Thanks, they look fine to me, although 1/x can use a lightly longer
> changelog, making it explicit its a filter for conditional branches.
> 
> How do people want this routed? Should I take all patches through tip,
> or do I ask Ingo to create a special perf/cond branch which includes the
> first 4 patches which can be merged into whatever ppc branch and the
> rest then go on top in the ppc tree?

Hi Peter,

Can you take just the first 4 in your tree please. I asked Anshuman to just
send those 4 but he & I seem to have miscommunicated on that.

We only depend on patch 1 in order for the powerpc parts to build, so I think
we'll just merge that into the powerpc tree and it should merge fine when it
hits next.

cheers


