Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab3BUS2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:28:08 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:35406 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab3BUS2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:28:06 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302211920440.22263@ionos>
References: <1361373336-11337-1-git-send-email-fweisbec@gmail.com>
	<alpine.LFD.2.02.1302202155320.22263@ionos>
	<CA+55aFwTFOsRTX3pHeZ+664rAms-Liwco3scEPJum6=C3BCoEQ@mail.gmail.com>
	<alpine.LFD.2.02.1302211920440.22263@ionos>
Date: Thu, 21 Feb 2013 10:28:04 -0800
X-Google-Sender-Auth: XjUN1eBP-oMhOxUkMwqJexP-Gk0
Message-ID: <CA+55aFwj0bVS0H1YBMq9EHbkYrU7-so8S6onCKs2M1Q+g4AmNA@mail.gmail.com>
Subject: Re: [PATCH] nohz: Make tick_nohz_irq_exit() irq safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 10:21 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> This was a draft patch. I made it a WARN_ON_ONCE() already.

Ok, good.

I really wish we could just get rid of BUG_ON(). It was a bad idea,
and it makes it easy for people to do the wrong thing. Sadly, we have
tons of them.

                        Linus
