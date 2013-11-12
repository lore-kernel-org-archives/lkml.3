Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab3KLOZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:25:07 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:52350 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3KLOZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:25:01 -0500
Date: Tue, 12 Nov 2013 15:24:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86/smpboot: Make the code more consistent
Message-ID: <20131112142457.GB21707@gmail.com>
References: <20131111170558.GA12741@gmail.com>
 <CAE9FiQWrzZB+wpSXGeQTPKi2o7MKvONFkk0_POe-E+wco07Erw@mail.gmail.com>
 <20131112103422.GA12849@pd.tnic>
 <20131112112338.GA12801@gmail.com>
 <20131112113208.GC12849@pd.tnic>
 <20131112113710.GA12998@gmail.com>
 <20131112115230.GD12849@pd.tnic>
 <20131112123937.GA13057@gmail.com>
 <20131112140430.GE12849@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112140430.GE12849@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Tue, Nov 12, 2013 at 01:39:37PM +0100, Ingo Molnar wrote:
> > Mind applying the attached cleanup patch first, before doing fixes to
> > the printout? No change in functionality. Mildly tested.
> 
> Yeah, boots fine in my strange topology kvm configuration here. We still
> need http://git.kernel.org/tip/2a929242ee50db84c1a561c81897bb0551f2c32f
> as I don't see it in Linus' tree as of now.

I'm sending locking/core to Linus later today.

Thanks,

	Ingo
