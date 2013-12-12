Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3LLLDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:03:49 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:41633 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3LLLDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:03:47 -0500
MIME-Version: 1.0
In-Reply-To: <26167386.hX5eWUjT6T@flatron>
References: <1386825152-398-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
	<26167386.hX5eWUjT6T@flatron>
Date: Thu, 12 Dec 2013 16:33:46 +0530
Message-ID: <CAAunhULO5n3rf5_Q+HwExd=kadsPC_rTz9oP8kXKM7krBetbdQ@mail.gmail.com>
Subject: Re: [PATCH CFT] ARM:S5P64X0: Enable ARM_PATCH_PHYS_VIRT and
 AUTO_ZRELADDR by default
From: Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Kgene Kim <kgene.kim@samsung.com>, Patch Tracking <patches@linaro.org>,
        linaro-kernel@lists.linaro.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz

> Could you explain the purpose of this change on S5P64x0?
>
> This is actually quite a poor platform choice. As of today, the kernel
> is stuck with supporting just SMDK6440/6450 boards, which are proprietary
> development boards and it doesn't look like any further boards will show
> up in future. Kukjin has actually proposed removing support for this
> platform at all and I consider this reasonable.
>
> Kukjin, should we proceed with removal?

The purpose of this patch is with the greater intent of consolidating
ARM-32 kernel. Which means a generic kernel for ARM-32 processors.

Hence these platform supported configs are introduced as default for
that particular platform.

I hope i answered your question. Else please mail me with further queries.

thanks
Panchaxari
