Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaLREX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 23:23:29 -0500
Received: from ozlabs.org ([103.22.144.67]:44301 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbaLREX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 23:23:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Lapitsky <lex.public@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: BUG_ON in virtio-ring.c
In-Reply-To: <CAAts5mPGV+u+r5cr4Ry+ePOpJSDY0BKY_T4A+hPaXVTWXL=TDg@mail.gmail.com>
References: <CAPM=9tyLrJ8VAdGCw_1guRS-ogCPE1Qp7faE_nrx_dAm2gvHLQ@mail.gmail.com> <87vc65p5a7.fsf@rustcorp.com.au> <CAPM=9tzw8jEv8yoLr7ktjO2DHCDzA+mURmJ-DXby_nsWUUNoyg@mail.gmail.com> <87li71oucu.fsf@rustcorp.com.au> <CAAts5mM_+Mj=vjWyJc8wZCvZehfK5dZxeA0Y9eowHwFDiWxo9Q@mail.gmail.com> <87fvesedfd.fsf@rustcorp.com.au> <CAAts5mPGV+u+r5cr4Ry+ePOpJSDY0BKY_T4A+hPaXVTWXL=TDg@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 18 Dec 2014 13:43:11 +1030
Message-ID: <87tx0ttzug.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Lapitsky <lex.public@gmail.com> writes:
> Hi,
>
> Sorry for the long delay. It prints exactly the same:
>
> [    3.792033] virtqueue elements = 128, max_segments = 126 (1 queues)
> [    3.802191]  vda: vda1 vda2 < vda5 >
>
> A little bit more about my setup (if it helps):

OK, I think this is fixed by Ming Lei's recent count updates,
which interestingly did not seem to be CC:stable.

Cheers,
Rusty.
