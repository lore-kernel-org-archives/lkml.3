Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3EXJXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:23:07 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52164 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3EXJXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:23:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_v3oNBP5DcqJ9bkGKkCDqwr1UzJNnVT6uz8V--FWEQ0Q@mail.gmail.com>
References: <CAPgLHd_v3oNBP5DcqJ9bkGKkCDqwr1UzJNnVT6uz8V--FWEQ0Q@mail.gmail.com>
Date: Fri, 24 May 2013 11:23:04 +0200
Message-ID: <CACRpkdbAhSRLpvLt8K8suL57cs7ts7rH-SqHJgQc1LA96=JO8Q@mail.gmail.com>
Subject: Re: [PATCH -next] pinctrl: sunxi: fix error return code in sunxi_pinctrl_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 11:32 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the devm_clk_get() error
> handling case instead of 0, as done elsewhere in this function.
>
> Introduced by commit 950707c0eb5c7aeaa2c446a04c824f4be686d2f6
> (pinctrl: sunxi: add clock support)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Patch applied for fixes, thanks!

Maxime: OK?

Yours,
Linus Walleij
