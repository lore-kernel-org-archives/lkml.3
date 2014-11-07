Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaKGWs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:48:27 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:43261 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbaKGWsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:48:23 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, mturquette@linaro.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Tony Xie <xxx@rock-chips.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 0/5] This is the 1st version of suspend for RK3288.
References: <1415368177-6637-1-git-send-email-zyw@rock-chips.com>
Date: Fri, 07 Nov 2014 14:48:20 -0800
In-Reply-To: <1415368177-6637-1-git-send-email-zyw@rock-chips.com> (Chris
	Zhong's message of "Fri, 7 Nov 2014 21:49:32 +0800")
Message-ID: <7hwq76pqyz.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Zhong <zyw@rock-chips.com> writes:

> RK3288 can shut down the cpu, gpu and other device controllers in suspend,
> and it will pull the GLOBAL_PWROFF pin to high in the final stage of the
> process of suspend, pull the pin to low again when resume.

The cover letter still doesn't state what this series applies to, or
what its dependencies are for testing, even though it was requested in
earlier reviews[1].  I discovered (again) by trial and error it applies
to current linux-next.  I also discovered (as was earlier discussed[2])
that it still does not resume using current upstream code, and those
dependencies are not described here either.  These are the kinds of
things that are crucial in a cover letter in order to help reviewers and
testers not have to spend time digging through the archives trying to
remember from the previous round of reviews. 

Please, please list the out-of-tree dependencies, and how to test,
including how you tested it, and on what hardware.

Speaking of earlier reviews, I've noticed that after reviewing this
series multiple times, you never respond to questions and/or comments.
Two-way communication is important when collaborating on getting complex
code this upstream, so please take some time to acknowledge the comments
of reviewers and engage in discussion when questions are asked.  Even if
it's as simple as "OK, I'll fix it in the next version", that helps
reviewers know that they're not wasting their time.

Kevin

[1] https://lkml.org/lkml/2014/10/29/759
[2] https://lkml.org/lkml/2014/10/29/881
