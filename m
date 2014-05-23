Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaEWJO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:14:26 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:56175 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaEWJOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:14:24 -0400
MIME-Version: 1.0
In-Reply-To: <1400146676-30343-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400146676-30343-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Fri, 23 May 2014 11:14:23 +0200
Message-ID: <CACRpkdYdvNeVh7tafCsZMtPrG5Q=iZs3tRJ5-fHoe1-kp-25Fg@mail.gmail.com>
Subject: Re: [PATCH v2 13/14] mmc: mmci: add qcom specific clk control
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 11:37 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> On Qcom SD card controller, cclk is mclk and mclk should be directly
> controlled by the driver.
> This patch adds support to control mclk directly in the driver, and also
> adds explicit_mclk_control and cclk_is_mclk flags in variant structure giving
> more flexibility to the driver.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
(...)
> +       bool                    qcom_cclk_is_mclk;

I have no idea why you prefix that with "qcom" since it's an
abstract concept.

But it's a very minor issue, so:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
