Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaKKHLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:11:25 -0500
Received: from regular1.263xmail.com ([211.150.99.139]:44940 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaKKHLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:11:23 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: linux-arm-kernel@lists.infradead.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <8fc047f9f3721bc8988207e2692fa900>
X-DNS-TYPE: 0
Message-ID: <5461B681.5020900@rock-chips.com>
Date: Tue, 11 Nov 2014 15:10:57 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@kernel.org>
CC: heiko@sntech.de, dianders@chromium.org, mturquette@linaro.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Tony Xie <xxx@rock-chips.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 0/5] This is the 1st version of suspend for RK3288.
References: <1415368177-6637-1-git-send-email-zyw@rock-chips.com> <7hwq76pqyz.fsf@deeprootsystems.com>
In-Reply-To: <7hwq76pqyz.fsf@deeprootsystems.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin

On 11/08/2014 06:48 AM, Kevin Hilman wrote:
> Chris Zhong <zyw@rock-chips.com> writes:
>
>> RK3288 can shut down the cpu, gpu and other device controllers in suspend,
>> and it will pull the GLOBAL_PWROFF pin to high in the final stage of the
>> process of suspend, pull the pin to low again when resume.
> The cover letter still doesn't state what this series applies to, or
> what its dependencies are for testing, even though it was requested in
> earlier reviews[1].  I discovered (again) by trial and error it applies
> to current linux-next.  I also discovered (as was earlier discussed[2])
> that it still does not resume using current upstream code, and those
> dependencies are not described here either.  These are the kinds of
> things that are crucial in a cover letter in order to help reviewers and
> testers not have to spend time digging through the archives trying to
> remember from the previous round of reviews.
Thank you for your review, I will perfect the cover letter in next 
version patches.

> Please, please list the out-of-tree dependencies, and how to test,
> including how you tested it, and on what hardware.
>
> Speaking of earlier reviews, I've noticed that after reviewing this
> series multiple times, you never respond to questions and/or comments.
> Two-way communication is important when collaborating on getting complex
> code this upstream, so please take some time to acknowledge the comments
> of reviewers and engage in discussion when questions are asked.  Even if
> it's as simple as "OK, I'll fix it in the next version", that helps
> reviewers know that they're not wasting their time.
OK, I'm going to respond all, even though only "Done".

> Kevin
>
> [1] https://lkml.org/lkml/2014/10/29/759
> [2] https://lkml.org/lkml/2014/10/29/881
>
>
>


