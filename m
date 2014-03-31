Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaCaU3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:29:34 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37946 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaCaU3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:29:33 -0400
Date: Mon, 31 Mar 2014 16:29:16 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/iommu change for v3.15
Message-ID: <20140331202916.GC8050@hmsreliant.think-freely.org>
References: <20140331144934.GA12335@gmail.com>
 <CA+55aFyAi0Vh6L5C8G6Jm3-FP81TNZekM_MiN-0wA3vvg3tSCQ@mail.gmail.com>
 <alpine.DEB.2.02.1403312144280.14882@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403312144280.14882@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 09:45:43PM +0200, Thomas Gleixner wrote:
> On Mon, 31 Mar 2014, Linus Torvalds wrote:
> 
> > On Mon, Mar 31, 2014 at 7:49 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > > Neil Horman (1):
> > >       x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets
> > 
> > Before I pull this, I want somebody to double-check it:
> > 
> > > -       if (revision == 0x13)
> > > +       if (revision < 0x13)
> > >                 set_irq_remapping_broken();
> > 
> > This change does *not* match the comment just above it. The comment
> > talks very much about revision 13.
> > 
> > So the comment should be fixed, and/or that "< 0x13" should perhaps be
> > "<= 0x13".
> > 
> > Because making it "less than" simply makes no sense in light of the
> > comment. Does revision 13 suddenly work? Was that where it was fixed?
> > If so, please fix the comment.
> 
> That is my bad. I applied V1 of the patch instead of V2 which had the
> <= 0x13 instead of < 0x13.
> 
> Please drop the pull request for now. I'll fix it up and we resubmit.
> 
> Thanks,
> 
> 	tglx
> 
> 
What Thomas said.  That was caught and fixed already.  sorry for the noise.
Neil

