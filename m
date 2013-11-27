Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab3K0Xsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:48:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54010 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab3K0Xsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:48:35 -0500
Message-ID: <529684AB.6090804@zytor.com>
Date: Wed, 27 Nov 2013 15:47:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
References: <5294F10C.8060901@amacapital.net> <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com> <52964EC7.9000504@zytor.com> <52966C0A.7070201@zytor.com> <20131127222104.GA748@pd.tnic> <b6331d08-d5fb-4ec5-80e2-ff32d3ce93ce@email.android.com> <20131127222944.GB748@pd.tnic> <529674C4.2030906@zytor.com> <20131127231010.GM32267@pd.tnic> <52967E27.3070906@zytor.com> <20131127234053.GO32267@pd.tnic>
In-Reply-To: <20131127234053.GO32267@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 03:40 PM, Borislav Petkov wrote:
> 
> But I'd guess that depends on the uarch because Bulldozer, reportedly,
> implements MFENCE by causing a pipeline stall which controls the
> prefetches too:
> 

An implementation can always make the memory model stronger, but not weaker.

	-hpa


