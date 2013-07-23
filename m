Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab3GWNag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:30:36 -0400
Received: from ozlabs.org ([203.10.76.45]:37693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239Ab3GWNaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:30:35 -0400
Date: Tue, 23 Jul 2013 23:30:32 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Scott Wood <scottwood@freescale.com>
Cc: Anton Blanchard <anton@samba.org>, Neil Horman <nhorman@tuxdriver.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] module: ppc64 module CRC relocation fix causes perf
 issues
Message-ID: <20130723133032.GB31944@concordia>
References: <20130718140045.6794ecd5@kryten>
 <1374274770.5357.33@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374274770.5357.33@snotra>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 05:59:30PM -0500, Scott Wood wrote:
> On 07/17/2013 11:00:45 PM, Anton Blanchard wrote:
> >
> >Hi Scott,
> >
> >> What specifically should I do to test it?
> >
> >Could you double check perf annotate works? I'm 99% sure it will but
> >that is what was failing on ppc64.
> 
> I'm not really sure what it's supposed to look like when "perf
> annotate" works.  It spits a bunch of unreadable[1]
> dark-blue-on-black assembly code at me, all with "0.00 :" in the
> left column.
> 
> Oh, wait -- some lines have "100.00 : " on the left, in
> even-more-unreadable dark-red-on-black.
> 
> Apart from the annoying colors, is there anything specific I should
> be looking for?  Some sort of error message, or output that actually
> makes sense?

The colours look fine on my terminal, so I don't know what you've done
there. If you care you can use "--stdio" to use the plainer interface,
though it still uses colours.

That output looks fine in terms of the bug Anton was chasing. As far as
only ever hitting one instruction that does look weird.

cheers
