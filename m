Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaEZJK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:10:58 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:41754 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaEZJK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:10:56 -0400
MIME-Version: 1.0
In-Reply-To: <1400849474-7177-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400849474-7177-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Mon, 26 May 2014 11:10:55 +0200
Message-ID: <CAPDyKFqfqhnCKA-dMqAfkhQ+cLLhN0vMtwTxB6t+MUju_04O-g@mail.gmail.com>
Subject: Re: [PATCH v3 03/13] mmc: mmci: Add Qualcomm Id to amba id table
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srinivas,

>
> +static struct variant_data variant_qcom = {
> +       .fifosize               = 16 * 4,
> +       .fifohalfsize           = 8 * 4,
> +       .clkreg                 = MCI_CLK_ENABLE,
> +       .datalength_bits        = 24,
> +       .blksz_datactrl4        = true,

You get compile error here.

Kind regards
Ulf Hansson
