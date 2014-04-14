Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaDNJr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:47:58 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:36381 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaDNJry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:47:54 -0400
Date: Mon, 14 Apr 2014 11:47:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
Message-ID: <20140414094749.GA731@gmail.com>
References: <6f5f98f2-aa96-433f-9ee8-5ba216624957@email.android.com>
 <20140412193541.GA30697@pd.tnic>
 <21a22ace-fbc3-4f97-a277-9cdf4f2253eb@email.android.com>
 <20140412201126.GC30694@pd.tnic>
 <CAMzpN2jHrBZ7DCd79GkCdjwCWJBv+YR5o9BGjypCdazJB9bJYQ@mail.gmail.com>
 <20140412205920.GD30694@pd.tnic>
 <CAMzpN2hkfw0p71H9QLFvbdmuiYqXqXJwBHK=GY_U_VHfjBL4Lg@mail.gmail.com>
 <20140412214034.GF30694@pd.tnic>
 <20140414072113.GA19569@gmail.com>
 <20140414094450.GA3663@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414094450.GA3663@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Apr 14, 2014 at 09:21:13AM +0200, Ingo Molnar wrote:
> > Apparently the game in question is "Exile: Escape from the pit":
> > 
> >   http://osdir.com/ml/wine-bugs/2014-04/msg01159.html
> 
> Ah, thanks.
> 
> Well, FWIW, you can get the game for free:
> 
> http://www.spiderwebsoftware.com/exile/winexile.html
> 
> I did run it on an old windoze guest I had lying around. Performance
> feels like native considering this game is from the previous century :-)

In fact it's from the previous millenium :-)

Thanks,

	Ingo
