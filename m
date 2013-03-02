Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab3CBBfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 20:35:31 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:54663 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab3CBBfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 20:35:30 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwNoK+Bt07s-fnxRSPHy3Cqq6yZtGP+B2ingxEnkArhVQ@mail.gmail.com>
References: <1362183392.3420.23.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFwNoK+Bt07s-fnxRSPHy3Cqq6yZtGP+B2ingxEnkArhVQ@mail.gmail.com>
Date: Fri, 1 Mar 2013 17:35:29 -0800
X-Google-Sender-Auth: PCUBEMezuyfCLykHeD-2XnTbJNk
Message-ID: <CA+55aFycg=7eyQRWg1Mp=NKcG1A=P5TLmDJw_OUEZynHRKfGZA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] ipc: do not hold ipc lock more than necessary
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 5:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Mar 1, 2013 at 4:16 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>>
>> With Rik's semop-multi.c microbenchmark we can see the following
>> results:
>
> Ok, that certainly looks very good.

Side note: it's fairly late in the merge window, and I don't feel
comfy merging this without more testing and more people looking at it,
so I think this is a 3.10 thing. But it would be great to see ipc
people really look at the patches, and perhaps run a few real loads to
see if it's even noticeable in practice..

              Linus
