Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbaJUVdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:33:53 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59381 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458AbaJUVdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:33:51 -0400
Message-ID: <5446D13C.5020402@codeaurora.org>
Date: Tue, 21 Oct 2014 14:33:48 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Jonathan Corbet <corbet@lwn.net>, Ralf Baechle <ralf@linux-mips.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?windows-1252?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Manuel Lauss <manuel.lauss@gmail.com>, Alex Elder <elder@linaro.org>,
        Matt Porter <mporter@linaro.org>, Tim Kryger <tim.kryger@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 6/8] clk: Change clk_ops->determine_rate to return
 a clk_hw as the best parent
References: <1413812442-24956-1-git-send-email-tomeu.vizoso@collabora.com> <1413812442-24956-7-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1413812442-24956-7-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 06:40 AM, Tomeu Vizoso wrote:
> This is in preparation for clock providers to not have to deal with struct clk.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>
>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

