Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaCaQNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:13:22 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:34184 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaCaQNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:13:20 -0400
MIME-Version: 1.0
In-Reply-To: <1396239636.5361.57.camel@marge.simpson.net>
References: <1396164244.28950.15.camel@marge.simpson.net>
	<CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
	<1396239636.5361.57.camel@marge.simpson.net>
Date: Mon, 31 Mar 2014 09:13:20 -0700
X-Google-Sender-Auth: 0Bx91DpuQVUuzzfTAqCio_3Oo88
Message-ID: <CA+55aFywHpvUfghS4GFc3UC1WGZx3Of+zeKHxmRNcMQMoKoiJQ@mail.gmail.com>
Subject: Re: [PATCH] sched: update_rq_clock() must skip ONE update
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 9:20 PM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
>
> Point of being verbose was to make sure it was clear exactly how this
> harmless little bug selectively kills large IO boxen..

My point is that if you want it to be applied hours before I make a
release, I need to be made aware of how critical it is.

The data/commentary in the commit message made *zero* sense to me in
that regards. It was just noise. The fact that I was explicitly cc'd
made me think that you considered it critical and that I should apply
it. The fact that the commit message was entirely jocular, mixed in
with "hard data" that didn't actually explain anything, then made me
go "Maybe it's not critical".

See where I'm coming from?

              Linus
