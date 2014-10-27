Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaJ0BjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:39:09 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:47802 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaJ0BjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:39:08 -0400
Date: Mon, 27 Oct 2014 02:38:58 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] tc: Error handling clean-ups
Message-ID: <20141027013857.GO16320@linux-mips.org>
References: <alpine.LFD.2.11.1404062030280.15266@eddie.linux-mips.org>
 <alpine.LFD.2.11.1410222234050.21390@eddie.linux-mips.org>
 <20141027101017.6af4e810@canb.auug.org.au>
 <alpine.LFD.2.11.1410270102540.21390@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1410270102540.21390@eddie.linux-mips.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 01:16:37AM +0000, Maciej W. Rozycki wrote:

> > >  I posted this fix originally to linux-mips@linux-mips.org back in April, 
> > > but it got lost and I don't want to give Ralf more stuff to handle than 
> > > absolutely necessary, he is really busy these days.  Can you please take 
> > > it directly to linux-next then?  There's nothing specific to MIPS in this 
> > > code really.
> > 
> > I don't take patches directly into linux-next (unless they are very
> > specific bug fixes for things that affect my builds - and even then I
> > only keep them until a maintainer picks them up).
> 
>  Good to know, will remember, thanks, and apologies to bother you then.  
> As the maintainer of this bus subsystem I wasn't sure what to do given 
> the situation.
> 
> > Sorry.  You could try sending it to Linus or Andrew Morton.
> 
>  Andrew, can you please take the change from the LKML message heading 
> this thread, or shall I resend it somehow for you to pick it up?  This 
> doesn't really fit anywhere.

The original patch is marked as rejected in patchwork - but I don't recall
why and the patch does look good and applies, so I just applied it.  Sorry,
probably fat fingered patchwork ...

  Ralf
