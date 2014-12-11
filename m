Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbaLKM0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:26:06 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34817 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaLKM0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:26:04 -0500
Date: Thu, 11 Dec 2014 13:25:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, v2] x86/microcode tree changes for v3.19
Message-ID: <20141211122558.GA18538@gmail.com>
References: <20141209132745.GA31656@gmail.com>
 <20141210124254.GA25436@gmail.com>
 <CA+55aFwiu2D=hKNvCvn-LL+TpYn9RS-N7+E8w7p+xLNdWSk8sA@mail.gmail.com>
 <20141211062508.GB5059@gmail.com>
 <20141211091238.GA31140@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141211091238.GA31140@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Dec 11, 2014 at 07:25:08AM +0100, Ingo Molnar wrote:
> > > Hmm. There's a conflict with commit 02ecc41abcea ("x86, 
> > > microcode: Limit the microcode reloading to 64-bit for now"), 
> > 
> > Sorry, should have mentioned that explicitly, but forgot about 
> > it.
> > 
> > > but I'm going to assume that the issue is fixed now, and that 
> > > commit fbae4ba8c4a3 ("x86, microcode: Reload microcode on 
> > > resume") that causes the conflict also handles the 32-bit case 
> > > correctly. So my merge is going to just remove the X86_64 test, 
> > > effectively undoing that first commit, ratehr than keep it 
> > > around.
> 
> Yes, this is the intended outcome.

Ok, great!

Thanks,

	Ingo
