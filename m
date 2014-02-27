Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaB0JSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:18:17 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:44357 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaB0JSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:18:13 -0500
MIME-Version: 1.0
In-Reply-To: <1392150132-21877-1-git-send-email-galak@codeaurora.org>
References: <1392150132-21877-1-git-send-email-galak@codeaurora.org>
Date: Thu, 27 Feb 2014 10:18:12 +0100
Message-ID: <CACRpkdZhsezPJd5q3ec7qh_6c+hQjQpi8iRiZHB2yT1T9bjPew@mail.gmail.com>
Subject: Re: [PATCH] gpio: msm: switch Kconfig to ARCH_QCOM depends
From: Linus Walleij <linus.walleij@linaro.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 9:22 PM, Kumar Gala <galak@codeaurora.org> wrote:

> We've split Qualcomm MSM support into legacy and multiplatform.  The gpio
> msm-v2 driver is only relevant on the multiplatform supported SoCs so
> switch the Kconfig depends to ARCH_QCOM.
>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
> Linus,
>
> If you can ack this I'll send it via linux-qcom/arm-soc tree's

Yeah:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

It took some time because your repeated pings bring the message
to the top of my mailbox and I process it from the bottom...

Yours,
Linus Walleij
