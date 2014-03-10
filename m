Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaCJJlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:41:14 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:47343 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaCJJlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:41:12 -0400
Message-ID: <531D886D.7080505@mm-sol.com>
Date: Mon, 10 Mar 2014 11:39:57 +0200
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org
CC: Wolfram Sang <wsa@the-dreams.de>, Chen-Yu Tsai <wens@csie.org>,
        Barry Song <Baohua.Song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Pavel Machek <pavel@ucw.cz>,
        Shawn Guo <shawn.guo@linaro.org>, Marek Vasut <marex@denx.de>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH] reset: Add optional resets and stubs
References: <1394202623-20229-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1394202623-20229-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/14 16:30, Philipp Zabel wrote:
> This patch adds device_reset_optional and (devm_)reset_control_get_optional
> variants that drivers can use to indicate they can function without control
> over the reset line. For those functions, stubs are added so the drivers can
> be compiled with CONFIG_RESET_CONTROLLER disabled.
> Also, device_reset is annotated with __must_check. Drivers ignoring the return
> value should use device_reset_optional instead.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Thanks.

Reviewed-by: Ivan T. Ivanov <iivanov@mm-sol.com>
