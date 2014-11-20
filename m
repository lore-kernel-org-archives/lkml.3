Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbaKTUdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:33:25 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:51753 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbaKTUdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:33:24 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411192311560.3909@nanos>
References: <546D0530.8040800@mit.edu>
	<a6cd3b60a3f53afb6e1c8081b0ec30ff19003dd7.1416434075.git.luto@amacapital.net>
	<alpine.DEB.2.11.1411192311560.3909@nanos>
Date: Thu, 20 Nov 2014 12:33:23 -0800
X-Google-Sender-Auth: SkFrnUeQlCvA_JuvHCpTjSJSKmY
Message-ID: <CA+55aFz-UKma1UmspBJExS5AH8sA=nTARR-G6JJeaMxN+K-WAw@mail.gmail.com>
Subject: Re: [PATCH] x86, syscall: Fix _TIF_NOHZ handling in syscall_trace_enter_phase1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Dave Jones <davej@redhat.com>,
        Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 2:13 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Right, while it is wrong it does not explain the wreckage on 3.17,
> which does not have that code.

Thomas, I'm currently going off the assumption that I'll see this from
the x86 trees, and I can ignore the patch. It doesn't seem like this
is a particularly pressing bug.

If it's *not* going to show up as a pull request, holler, and I'll
just apply it.

                    Linus
