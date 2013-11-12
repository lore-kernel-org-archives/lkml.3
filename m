Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3KLLw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 06:52:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44472 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab3KLLwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 06:52:55 -0500
Date: Tue, 12 Nov 2013 12:52:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/boot changes for v3.13
Message-ID: <20131112115230.GD12849@pd.tnic>
References: <20131111170558.GA12741@gmail.com>
 <CAE9FiQWrzZB+wpSXGeQTPKi2o7MKvONFkk0_POe-E+wco07Erw@mail.gmail.com>
 <20131112103422.GA12849@pd.tnic>
 <20131112112338.GA12801@gmail.com>
 <20131112113208.GC12849@pd.tnic>
 <20131112113710.GA12998@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131112113710.GA12998@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 12:37:10PM +0100, Ingo Molnar wrote:
> Hm, I think it's actually a bonus that we see the individual CPUs
> printed as they boot up. That way if there's a hang, the place where
> it hangs is apparent, etc.

Ok, good point.

We can do something like that then:

[    0.068574] x86: Booting SMP configuration:
[    0.069006] .... node  #1, CPUs:      #1
[    0.147005] .... node  #0, CPUs:   #2 #3
[    0.147005] .... node  #1, CPUs:   #4 #5
[    0.445273] x86: Booted up 2 nodes, 6 CPUs

and report (node, core) in the order they appear.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
