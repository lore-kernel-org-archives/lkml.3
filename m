Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3EZW7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 18:59:44 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:62206 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab3EZW7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 18:59:43 -0400
MIME-Version: 1.0
In-Reply-To: <1369601453.2259.15.camel@buesod1.americas.hpqcorp.net>
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
	<1369601453.2259.15.camel@buesod1.americas.hpqcorp.net>
Date: Sun, 26 May 2013 15:59:42 -0700
X-Google-Sender-Auth: Ie264op6CMMBYjSj_Ay93WMgZiA
Message-ID: <CA+55aFyhJTKsbx8DoRNC-gSQM7MNCSc-sntJn3fKn-S4jjF4-w@mail.gmail.com>
Subject: Re: [PATCH 0/4] ipc/sem.c: Bug fixes, regression fixes, v3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hai Huang <hhuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 1:50 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>
> In lack of getting my swingbench DSS environment back, I ran these
> changes against the semop-multi program on my laptop. For 256 threads,
> with Manfred's patchset the ops/sec suffers around -7.3%.

Hmm. That test program only tests simple ops, right? So the slowdown
comes from either the code simply being that much slower due to extra
complexity, or from the fair wakeups..

Anyway, I applied 1/4, we can continue to discuss the rest.

          Linus
