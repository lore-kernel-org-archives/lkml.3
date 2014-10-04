Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096AbaJDQ2B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 12:28:01 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:33763 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaJDQ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 12:28:00 -0400
MIME-Version: 1.0
In-Reply-To: <vi8ojsasknll8us53fy9myb8.1412439420039@email.android.com>
References: <20141004030438.28569.85536.stgit@linux-yegoshin>
	<20141004082307.GS10583@worktop.programming.kicks-ass.net>
	<CA+55aFynSp90n=jdUdmY7nq-9t4pHS82Tj-WfZOBfot7ip0hBw@mail.gmail.com>
	<vi8ojsasknll8us53fy9myb8.1412439420039@email.android.com>
Date: Sat, 4 Oct 2014 09:27:59 -0700
X-Google-Sender-Auth: yV-MScZqvL-kBcDRi9G1NoFUpNs
Message-ID: <CA+55aFxqip0m=Ohd-+VDEkzahhLDe+fj9kXY0bbQY8YMBTEc4A@mail.gmail.com>
Subject: Re: [PATCH 0/3] MIPS executable stack protection
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-mips <linux-mips@linux-mips.org>,
        Zubair Kakakhel <Zubair.Kakakhel@imgtec.com>,
        David Daney <david.daney@cavium.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        "chenhc@lemote.com" <chenhc@lemote.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        James Hogan <James.Hogan@imgtec.com>,
        Kees Cook <keescook@chromium.org>,
        "alex@alex-smith.me.uk" <alex@alex-smith.me.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Crispin <blogic@openwrt.org>,
        "jchandra@broadcom.com" <jchandra@broadcom.com>,
        Paul Burton <Paul.Burton@imgtec.com>,
        Qais Yousef <Qais.Yousef@imgtec.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <Markos.Chandras@imgtec.com>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "lars.persson@axis.com" <lars.persson@axis.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2014 at 9:17 AM, Leonid Yegoshin
<Leonid.Yegoshin@imgtec.com> wrote:
> Linus, it works on CPU with hardware page table walker - MIPS P5600 aka Apache.
>
> I was involved in architecture development of HTW and took care of it.

Ok, as long as it works architecturally, per-thread TLB fills are fine by me.

             Linus
