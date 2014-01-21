Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaAUN7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:59:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbaAUN66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:58:58 -0500
Date: Tue, 21 Jan 2014 14:58:54 +0100
From: Jan Kara <jack@suse.cz>
To: Nate Eldredge <nate@thatsmathematics.com>
Cc: George Spelvin <linux@horizon.com>, adilger@dilger.ca,
        arjan@linux.intel.com, jack@suse.cz, linux-kernel@vger.kernel.org,
        maarten-baert@hotmail.com, mingo@elte.hu, suresh.b.siddha@intel.com,
        tglx@linutronix.de, viro@zeniv.linux.org.uk
Subject: Re: math_state_restore and kernel_fpu_end disable interrupts?
Message-ID: <20140121135854.GE21195@quack.suse.cz>
References: <20140119210228.9598.qmail@science.horizon.com>
 <alpine.DEB.2.10.1401201915250.2663@minerva.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401201915250.2663@minerva.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 20-01-14 19:22:51, Nate Eldredge wrote:
> On Sun, 19 Jan 2014, George Spelvin wrote:
> 
> >>It's credited to Suresh Siddha, whom I've cc'ed (along with others who
> >>signed off).  Suresh, if you're still around, could you comment on why
> >>math_state_restore always leaves interrupts disabled, regardless of their
> >>state on entry?  Is there a deep reason or is it a bug?
> >
> >What the comments seemed to be implying was that it was a bug to enter
> >this code with interrupts enabled.  So the problem may be a little bit
> >more systemic; expert counsel is required.
> 
> It would be kind of weird for code that requires disabled interrupts
> on entry to turn around and enable interrupts itself.  I agree that
> it would really help for a guru to take a look...
> 
> On which note, Suresh's email bounced :-(
  Guys, since this is lurking without proper attention for a rather long
time, can you just write a patch which fixes the problem as far as you can
tell, test that the patch indeed fixes your problems and if yes, send it
to Ingo & LKML. If nothing else it should get you more attention.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
