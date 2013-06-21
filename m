Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab3FUBcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 21:32:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54859 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758018Ab3FUBcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 21:32:08 -0400
X-Sasl-enc: m2waCFSx5l//qhePyO2xWdiu178dGrRZvilh73xawceJ 1371778327
Date: Thu, 20 Jun 2013 18:32:06 -0700
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Status of __cpuinit removal
Message-ID: <20130621013206.GB21375@kroah.com>
References: <519AA53F.1020107@zytor.com>
 <20130520231203.GA21682@kroah.com>
 <20130528092038.GC32068@gmail.com>
 <CAP=VYLo047g+U3GJhkObJtNPubFNpHuGUJAF7oOh_7dPtSFd9A@mail.gmail.com>
 <20130612005605.GA7469@kroah.com>
 <20130620174659.GA17945@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620174659.GA17945@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 01:46:59PM -0400, Paul Gortmaker wrote:
> 
> The below pseudo-pull-request will show the scope of changes against
> the linux-next tree from today.  It is a real branch that people
> can pull and build/test against if they are interested in doing so.
> Or, just pull the patch queue and apply them yourself, if you prefer.
> 
> Thanks for reading this far and thanks for any feedback.

That all sounds like a great plan, thanks for doing this work.  At a
quick glance, it looks sane to me.

greg k-h
