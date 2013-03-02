Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3CBEla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 23:41:30 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64906 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3CBEl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 23:41:29 -0500
MIME-Version: 1.0
In-Reply-To: <1362183404.3420.25.camel@buesod1.americas.hpqcorp.net>
References: <1362183404.3420.25.camel@buesod1.americas.hpqcorp.net>
Date: Sat, 2 Mar 2013 12:41:28 +0800
Message-ID: <CANN689FuYfNZjPSPYFKq4HkN5MVe_dOOAm8yswKE=bvw8s4vUQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ipc: semaphores: do not hold ipc lock more than necessary
From: Michel Lespinasse <walken@google.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, "Vinod, Chegu" <chegu_vinod@hp.com>,
        "Low, Jason" <jason.low2@hp.com>, linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Ingo Molnar <mingo@kernel.org>, Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 8:16 AM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> Instead of holding the ipc lock for permissions and security
> checks, among others, only acquire it when necessary.
>
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

You got some really great test results on this; I think they deserve
to be mentioned in the commit message.

Code looks fine to me otherwise, but I only had a quick look.

Nice work!

Acked-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
