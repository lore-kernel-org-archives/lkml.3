Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3KRJtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:49:22 -0500
Received: from mail.abilis.ch ([195.70.19.74]:21173 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab3KRJsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:48:52 -0500
Date: Mon, 18 Nov 2013 10:48:08 +0100
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Roskin <proski@gnu.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, Noam Camus <noamc@ezchip.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [FIX] init/Kconfig: fix option to disable kernel
 compression
Message-ID: <20131118094807.GC31741@ab42.lan>
References: <1384494227-24029-1-git-send-email-hpa@zytor.com>
 <1384534267-14746-1-git-send-email-christian.ruppert@abilis.com>
 <52873E20.6010307@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52873E20.6010307@synopsys.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 03:12:56PM +0530, Vineet Gupta wrote:
> On 11/15/2013 10:21 PM, Christian Ruppert wrote:
> > Some architectures with self-decompressing kernel images did not compile
> > with commit 69f0554ec261fd686ac7fa1c598cc9eb27b83a80 because they don't
> > provide a non-decompression mechanism for uncompressed kernels.
> > 
> > Rectify this problem by allowing uncompressed kernels only for architectures
> > which explicitly state they support them.
> > 
> > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Acked-by: Vineet Gupta <vgupta@synopsys.com>

Looks like the revert was applied to main line (and not this fix). In
the follow-up the complete (fixed) patch set rebased on the latest main
line: First patch for Kconfig/ARC and as requested a cleaned up second
patch for x86. I could only test the second patch on one physical
machine and one VM so some more testing might be required on x86.

Greetings,
  Christian
