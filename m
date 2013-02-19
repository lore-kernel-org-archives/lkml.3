Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab3BSR5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:57:33 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:42463 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933025Ab3BSR5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:57:31 -0500
Date: Tue, 19 Feb 2013 12:57:27 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, boris.ostrovsky@oracle.com
Subject: Re: [GIT PULL] x86/cpu changes for v3.9
Message-ID: <20130219175726.GA18244@phenom.dumpdata.com>
References: <20130219152503.GA14862@gmail.com>
 <20130219153655.GD26748@pd.tnic>
 <20130219154721.GA15876@gmail.com>
 <5123B897.9010607@zytor.com>
 <20130219174758.GB4465@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219174758.GB4465@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 06:47:58PM +0100, Borislav Petkov wrote:
> On Tue, Feb 19, 2013 at 09:38:31AM -0800, H. Peter Anvin wrote:
> > My fault... I was tracking the fix and lost track of the thread.
> > 
> > The problem is that the fix is necessary but not sufficient, as it
> > introduces an undesirable host-guest dependency.  In order to allow
> > neerw guests to work on older hosts we also should use the
> > {rd,wr}msr_safe() functions to manipulate this MSR, with a comment
> > as to why.
> > 
> > Boris, could you prepare such a patch, please?
> 
> I don't think Boris O. is at AMD anymore. Want me to add that to my fix
> for kvm or prep a separate patch?

CC-ing Boris.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
