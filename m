Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3DUJvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 05:51:33 -0400
Received: from nctlincom01.orcon.net.nz ([60.234.4.69]:43115 "EHLO
	nctlincom01.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab3DUJvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 05:51:31 -0400
Date: Sun, 21 Apr 2013 21:51:20 +1200
From: Michael Cree <mcree@orcon.net.nz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Arch Mailing List <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Using __int128 on 64-bit architectures
Message-ID: <20130421095120.GA6508@omega>
Mail-Followup-To: Michael Cree <mcree@orcon.net.nz>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"Maciej W. Rozycki" <macro@linux-mips.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Arch Mailing List <linux-arch@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <51464C00.5090107@zytor.com>
 <alpine.LFD.2.03.1304210450490.17443@linux-mips.org>
 <20130421193531.43965f592f00dfd6e3cfcf45@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421193531.43965f592f00dfd6e3cfcf45@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Check: by mx5.orcon.net.nz on Sun, 21 Apr 2013 21:51:26 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Apr 21 21:51:28 2013
X-DSPAM-Confidence: 0.8509
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: -3.00 () [Hold at 4.00] CC(NZ:-3)
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=E7; city=Auckland; latitude=-36.8667; longitude=174.7667; http://maps.google.com/maps?q=-36.8667,174.7667&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 06JqxXUlF - c7fe49f4589f - 20130421
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 07:35:31PM +1000, Stephen Rothwell wrote:
> On Sun, 21 Apr 2013 05:29:28 +0100 (BST) "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
> >
> >  Hmm, nobody has replied, so just FYI such widening multiplication is 
> > available in all 64-bit MIPS hardware and GCC has supported it since 4.4 
> > or mid 2008 (older versions used a libgcc __multi3 helper, not quite so 
> > efficient as you can imagine).
> 
> i.e. for gcc 4.6.3, 64 bit powerpc calls out to __multi3
> 
> The same is true for sparc64.

Likewise, with gcc-4.6.3, alpha calls out to __multi3.

Cheers
Michael.
