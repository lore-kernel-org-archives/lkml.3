Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaEUMBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 08:01:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:39561 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaEUMBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 08:01:48 -0400
Date: Wed, 21 May 2014 14:01:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Fwd: [V6 00/11] perf: New conditional branch filter
Message-ID: <20140521120146.GD2485@laptop.programming.kicks-ass.net>
References: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
 <537C6DDE.9000204@linux.vnet.ibm.com>
 <20140521092313.GF30445@twins.programming.kicks-ass.net>
 <537C827B.9090505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <537C827B.9090505@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 04:09:55PM +0530, Anshuman Khandual wrote:
> On 05/21/2014 02:53 PM, Peter Zijlstra wrote:
> > On Wed, May 21, 2014 at 02:41:58PM +0530, Anshuman Khandual wrote:
> >> Hello Peter/Ingo,
> >>
> >> Would you please consider reviewing the first four patches in this patch series
> >> which changes the generic perf kernel and perf tools code. Andi Kleen and Stephane
> >> Eranian have already reviewed these changes. The rest of the patch series is related
> >> to powerpc and being reviewed by Michael Ellerman/Ben.
> >>
> > 
> > If they land in my inbox I might have a look.
> > 
> 
> Sent.

Thanks, they look fine to me, although 1/x can use a lightly longer
changelog, making it explicit its a filter for conditional branches.

How do people want this routed? Should I take all patches through tip,
or do I ask Ingo to create a special perf/cond branch which includes the
first 4 patches which can be merged into whatever ppc branch and the
rest then go on top in the ppc tree?
