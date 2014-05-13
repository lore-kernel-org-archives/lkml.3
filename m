Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbaEMHQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:16:36 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50261 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbaEMHQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:16:34 -0400
MIME-Version: 1.0
In-Reply-To: <1398759542-13017-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1398759542-13017-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Tue, 13 May 2014 09:16:33 +0200
Message-ID: <CACRpkdZyEAkJUGC5x6CY65-g97jfyg-TMDoe8JxDMexVx5usSA@mail.gmail.com>
Subject: Re: [PATCH v1 01/11] ARM: amba: Add Qualcomm vendor ID.
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 10:19 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> This patch adds Qualcomm amba vendor Id to the list. This ID is used in mmci
> driver.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
(...)
> +       AMBA_VENDOR_QCOM = 0x51,

Yeah it's a "Q", like 0x41 is "A" for ARM. You could as well mention
this in the commit message.

And you can probably just put this patch into Russell's patch tracker
already.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
