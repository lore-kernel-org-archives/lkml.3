Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaJIBco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 21:32:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51081 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaJIBce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 21:32:34 -0400
Message-ID: <5435E5B0.90900@codeaurora.org>
Date: Wed, 08 Oct 2014 18:32:32 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Alex Elder <elder@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-omap@vger.kernel.org,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Matt Porter <mporter@linaro.org>, Ralf Baechle <ralf@linux-mips.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v2 0/8] Per-user clock constraints
References: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 08:21 AM, Tomeu Vizoso wrote:
> Hello,
>
> this second version of the series adds several cleanups that were suggested by
> Stephen Boyd and contains several improvements to the seventh patch (clk: Make
> clk API return per-user struct clk instances) that were suggested by him during
> the review of v1.
>
> The first six patches are just cleanups that should be desirable on their own,
> and that should make easier to review the actual per-user clock patch.
>
> The seventh patch actually moves the per-clock data that was stored in struct
> clk to a new struct clk_core and adds references to it from both struct clk and
> struct clk_hw. struct clk is now ready to contain information that is specific
> to a given clk consumer.
>
> The eighth patch adds API for setting floor and ceiling constraints and stores
> that information on the per-user struct clk, which is iterable from struct
> clk_core.
>
>

As said in the patches, can you please indicate which baseline this is 
on? Also can you rebase onto clk-next if you send again before that is 
merged into 3.18-rc1? There are some changes in the debugfs part that 
will conflict. I'll review the more complicated parts in detail soon.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

