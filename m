Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3KKUJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:09:54 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54107 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab3KKUJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:09:46 -0500
Date: Mon, 11 Nov 2013 21:09:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
Message-ID: <20131111200942.GC17408@gmail.com>
References: <1381450698-28710-4-git-send-email-keescook@chromium.org>
 <tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org>
 <20131111182046.GA14961@gmail.com>
 <52812F92.1020006@zytor.com>
 <CAGXu5j+66dfv_048iDp+ZAv4_sS4si9cHG-8L_4zJ1OHHLxaUw@mail.gmail.com>
 <52813334.2040405@zytor.com>
 <20131111195852.GA17408@gmail.com>
 <52813842.40709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52813842.40709@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/11/2013 11:58 AM, Ingo Molnar wrote:
> >>
> >> Use the i8254 if and only if nothing else is available, it isn't safe to
> >> touch on some newer systems.
> > 
> > I concur - the i8254 is probably also a low entry source, given that this 
> > all runs early bootup.
> > 
> 
> Well, it is a 16-bit 1.19318 MHz counter so at least on older systems it 
> is likely to provide at least a modicum on entropy.  On systems with a 
> TSC it is likely to be redundant with the TSC.

Yeah.

Thanks,

	Ingo
