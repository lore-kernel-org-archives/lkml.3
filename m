Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbaIWU75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:59:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57631 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822AbaIWU7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:59:54 -0400
Message-ID: <5421DF46.2010107@codeaurora.org>
Date: Tue, 23 Sep 2014 13:59:50 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, tomasz.figa@gmail.com, rabin@rab.in,
        Thierry Reding <thierry.reding@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 0/9] Per-user clock constraints
References: <1411497613-24049-1-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1411497613-24049-1-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/14 11:40, Tomeu Vizoso wrote:
> Hello,
>
> this version of the patchset addresses some issues that Russell pointed out
> yesterday:
>
> * Refactor the changes to clkdev.c to reduce the amount of ifdefs.
>
> * Properly release clocks when there isn't enough memory to create the per-user
> wrapper.
>
> * Add clk_provider_put(struct clk_core*) for clock implementations to call
> instead of clk_put(struct clk*) (instead of exposing __clk_put).
>
> As the previous versions, this is based on top of 3.17-rc4 and Mike's patch at
> [0].

Any thoughts on my comments on patch set #10[1]? It seems like we can
avoid having a flag day to support this.

[1] https://lkml.org/lkml/2014/9/9/960

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

