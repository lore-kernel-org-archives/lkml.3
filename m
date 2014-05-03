Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaECAMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 20:12:02 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:51074 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaECAMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 20:12:00 -0400
MIME-Version: 1.0
In-Reply-To: <7982b18cef5056c6f2a46ff7cc40893d1dddd3c0.1399074537.git.luto@amacapital.net>
References: <7982b18cef5056c6f2a46ff7cc40893d1dddd3c0.1399074537.git.luto@amacapital.net>
Date: Fri, 2 May 2014 17:11:59 -0700
X-Google-Sender-Auth: 18XE3HuPMHml2gelao9e9a4j-Hg
Message-ID: <CA+55aFw_fz=eDPK+8v=7B=jkyhN8YDRCNJgq8XSo_NJLxB8z+w@mail.gmail.com>
Subject: Re: [PATCH] x86: Return to kernel without IRET
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 4:51 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On my box, this saves about 100ns on each interrupt and trap that
> happens while running in kernel space.  This speeds up my kernel_pf
> microbenchmark by about 17%.

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

Now it just needs lots of testing to make sure it's all good. But I
can't imagine what would go wrong.

               Linus
