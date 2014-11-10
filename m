Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaKJSY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:24:26 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57579 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaKJSYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:24:23 -0500
Date: Mon, 10 Nov 2014 19:17:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Anvin <hpa@zytor.com>, Jan Beulich <JBeulich@suse.com>,
        tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org,
        Tony Jones <tonyj@suse.de>
Subject: Re: [PATCH, RFC] x86: also CFI-annotate certain inline asm()s
Message-ID: <20141110181704.GA25757@gmail.com>
References: <5458A9600200007800044AE5@mail.emea.novell.com>
 <20141110100117.GA15841@gmail.com>
 <CA+55aFw9MV1n8T7_k5oftfY-sOu8s1ywKYM-3k4+PF022vv9ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw9MV1n8T7_k5oftfY-sOu8s1ywKYM-3k4+PF022vv9ow@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Nov 10, 2014 2:01 AM, "Ingo Molnar" <mingo@kernel.org> wrote:
> >
> > (Assuming nobody objects strongly.)
> 
> I object strongly to anything this disgustingly ugly, 
> especially since it doesn't even have a strong stated reason.

Fair enough!

Thanks,

	Ingo
