Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaD1J2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:28:34 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:62872 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaD1J2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:28:31 -0400
Date: Mon, 28 Apr 2014 10:28:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Silvio F <silvio.fricke@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com
Subject: Re: [PATCH 3/6 v3] mfd: stmpe: probe properly from the device tree
Message-ID: <20140428092825.GM6264@lee--X1>
References: <1398288958-4723-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398288958-4723-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The current STMPE I2C probing code does not really match the
> compatible strings - it matches node names happening to give
> the right device name. Instead, let's introduce some real
> compatible matching, more complex, more accurate. Make the
> driver depend on OF since all platforms using it are DT-only.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Fix a stupid error where I left a dangling return statement
>   in the probe path.
> - Fix up subject prope->probe
> ChangeLog v1->v2:
> - Make driver depend on OF and remove some ifdeffery that way.
> - Squash OF match table to single lines.
> - Merge of-specific probe function into probe().
> - Print a small nag if DT is using the node name trick to make
>   the driver probe.
> ---
>  drivers/mfd/Kconfig     |  1 +
>  drivers/mfd/stmpe-i2c.c | 30 +++++++++++++++++++++++++++++-
>  2 files changed, 30 insertions(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
