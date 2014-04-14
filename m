Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaDNHVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:21:21 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:43760 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaDNHVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:21:18 -0400
Date: Mon, 14 Apr 2014 09:21:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
Message-ID: <20140414072113.GA19569@gmail.com>
References: <CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
 <CAMzpN2jn69_E7UEP6OHBbc4r7UuJbsW50WA25YhXuQs5sHFxQQ@mail.gmail.com>
 <6f5f98f2-aa96-433f-9ee8-5ba216624957@email.android.com>
 <20140412193541.GA30697@pd.tnic>
 <21a22ace-fbc3-4f97-a277-9cdf4f2253eb@email.android.com>
 <20140412201126.GC30694@pd.tnic>
 <CAMzpN2jHrBZ7DCd79GkCdjwCWJBv+YR5o9BGjypCdazJB9bJYQ@mail.gmail.com>
 <20140412205920.GD30694@pd.tnic>
 <CAMzpN2hkfw0p71H9QLFvbdmuiYqXqXJwBHK=GY_U_VHfjBL4Lg@mail.gmail.com>
 <20140412214034.GF30694@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140412214034.GF30694@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Sat, Apr 12, 2014 at 05:13:40PM -0400, Brian Gerst wrote:
> > Performance is bad in general, running a 32-bit Fedora 20 guest.
> 
> So this means you haven't tried the game in the guest yet, so that 
> we can know for sure that a guest doesn't solve your problem or 
> what?
> 
> Btw, which game is that and can I get it somewhere to try it here 
> locally?

Apparently the game in question is "Exile: Escape from the pit":

  http://osdir.com/ml/wine-bugs/2014-04/msg01159.html

Thanks,

        Ingo

