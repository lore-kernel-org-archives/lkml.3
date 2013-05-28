Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776Ab3E1JUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:20:43 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33485 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933724Ab3E1JUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:20:42 -0400
Date: Tue, 28 May 2013 11:20:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Get rid of cpuinit?
Message-ID: <20130528092038.GC32068@gmail.com>
References: <519AA53F.1020107@zytor.com>
 <20130520231203.GA21682@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520231203.GA21682@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> On Mon, May 20, 2013 at 03:35:43PM -0700, H. Peter Anvin wrote:
> > We have gotten rid of devinit markup.  A recent patch of Linus' makes me
> > wonder if we similarly should get rid of cpuinit markup?
> > 
> > Just as with devices, the CPU hotplug machinery has been leveraged to
> > support a number of pieces of functionality such as suspend, which means
> > that on anything but the most embedded systems this functionality is
> > likely needed anyway.
> > 
> > On x86-64, for an "allyesconfig" build, the total amount of space in all
> > the .cpu* sections combined is 100K.
> 
> No objection from me on removing it, it just causes problems from what I
> can tell.

Indeed, there's a steady trickle of mis-annotated cpuinit sections, and no 
real tooling to make the annotations automatic or so in most of the cases. 
Manual simply does not seem to work in this case.

Thanks,

	Ingo
