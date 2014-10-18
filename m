Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaJRP23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 11:28:29 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51233 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaJRP2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 11:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <1413615285.5741.41.camel@marge.simpson.net>
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
	<1413615285.5741.41.camel@marge.simpson.net>
Date: Sat, 18 Oct 2014 08:28:23 -0700
X-Google-Sender-Auth: c1QA9ZlUaYOPh5nyA1JkKD1L8gs
Message-ID: <CA+55aFydqk0NVcYHForRCXVJj_Tw+T+ZW9GikAmUXdOgdpGf5A@mail.gmail.com>
Subject: Re: [PATCH] futex: Ensure get_futex_key_refs() always implies a barrier
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Franchin <Matteo.Franchin@arm.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 11:54 PM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
>
> The barrier fixing up my problematic box smells a lot like evidence.

Is this a "tested-by"? Did you actuallyu verify that the patch ends up
fixing the problem you saw?

            Linus
