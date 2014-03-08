Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaCHNvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 08:51:41 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:50441 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaCHNvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 08:51:35 -0500
X-Auth-Info: LwvdpuZZ/8FsqWEPIRlQPiHc1ffVatX1EuLHcfgo5no=
From: Marek Vasut <marex@denx.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH] reset: Add optional resets and stubs
Date: Sat, 8 Mar 2014 12:38:09 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Chen-Yu Tsai" <wens@csie.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Barry Song <Baohua.Song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Pavel Machek <pavel@ucw.cz>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        kernel@pengutronix.de
References: <1394202623-20229-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1394202623-20229-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201403081238.09405.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 07, 2014 at 03:30:23 PM, Philipp Zabel wrote:
> This patch adds device_reset_optional and (devm_)reset_control_get_optional
> variants that drivers can use to indicate they can function without control
> over the reset line. For those functions, stubs are added so the drivers
> can be compiled with CONFIG_RESET_CONTROLLER disabled.
> Also, device_reset is annotated with __must_check. Drivers ignoring the
> return value should use device_reset_optional instead.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Nice.

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
