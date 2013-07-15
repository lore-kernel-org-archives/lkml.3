Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3GOTBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:01:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43864 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab3GOTBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:01:11 -0400
Message-ID: <51E446C2.6050508@zytor.com>
Date: Mon, 15 Jul 2013 12:00:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tim Northover <t.p.northover@gmail.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LLVMdev <llvmdev@cs.uiuc.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [LLVMdev] [PATCH] x86/asm: avoid mnemonics without type suffix
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com> <CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com> <CAFHTzf+PTVBcMYy2NQBQDLQgsWjbUBc+FYp2Hokd-002hXrePA@mail.gmail.com> <CA+55aFwpfn9FjkYeVpA8aPiGy6o8Z-JgJUNFmKF3H7nGqmbi+w@mail.gmail.com> <CAFHTzf+O7sdeETp5nsnoQDFeg-zE4q6Kmq9rHPZEr5z2jm2zxg@mail.gmail.com> <CA+55aFwcxWR-SFD=QFXAb38sPnN-hcOBF-W+NuRBSMx-n+RnxQ@mail.gmail.com> <51E44204.4000802@zytor.com> <CA+55aFy=w6v9MqcVn1H6X7jqJq+QrEx7TfA6Kr+vC4SYJRjUyQ@mail.gmail.com>
In-Reply-To: <CA+55aFy=w6v9MqcVn1H6X7jqJq+QrEx7TfA6Kr+vC4SYJRjUyQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 11:56 AM, Linus Torvalds wrote:
> 
> (NASM used to be *much* more pleasant to work with than gas. Maybe you
> should strive to make nasm DTRT wrt bt and constants, and maintain
> that lead?)
> 

Yes, that is in fact why I took over NASM development when Simon Tatham
gave up on it.  I'll look at adding this in the next version, it should
be easy enough.

	-hpa


