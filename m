Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaACAux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:50:53 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38626 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaACAuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:50:52 -0500
MIME-Version: 1.0
In-Reply-To: <1388704274-5278-1-git-send-email-john.stultz@linaro.org>
References: <52C5E675.80701@linaro.org>
	<1388704274-5278-1-git-send-email-john.stultz@linaro.org>
Date: Thu, 2 Jan 2014 16:50:50 -0800
X-Google-Sender-Auth: O7pquY7C-0mAUD9J-3sfCujC_jQ
Message-ID: <CA+55aFxv8wTRifZ9iHn-tCfUqwpJZmLiF7QU=Pc6dVa8QnTyCQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] seqlock: Use raw_ prefix instead of _no_lockdep
From: Linus Torvalds <torvalds@linux-foundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 2, 2014 at 3:11 PM, John Stultz <john.stultz@linaro.org> wrote:
> Linus disliked the _no_lockdep() naming, so instead
> use the more-consistent raw_* prefix to the non-lockdep
> enabled seqcount methods.
>
> This also adds raw_ methods for the write operations
> as well, which will be utilized in a following patch.

Ack on this and on 2/2. I'm assuming I'll get them through the -tip
tree, which is where the problem came from. No?

               Linus
