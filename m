Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbaGWOwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:52:42 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43325 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598AbaGWOwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:52:40 -0400
MIME-Version: 1.0
In-Reply-To: <1405716797-28122-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1405625780-13503-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1405716797-28122-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Wed, 23 Jul 2014 16:52:39 +0200
Message-ID: <CACRpkdbX350uaHHFHpy7km0Pu4aiSqu-bdontdhJiRM39k-LUA@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: mmci: Add qcom dml support to the driver.
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 10:53 PM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:

> On Qualcomm APQ8064 SOCs, SD card controller has an additional glue
> called DML (Data Mover Local/Lite) to assist dma transfers.
> This hardware needs to be setup before any dma transfer is requested.
> DML itself is not a DMA engine, its just a gule between the SD card
> controller and dma controller.
>
> Most of this code has been ported from qualcomm's 3.4 kernel.
>
> This patch adds the code necessary to intialize the hardware and setup
> before doing any dma transfers.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> Changes since v1:
>    - Added licence text as spotted by Stephen B.
>    - Simplified dma channel lookup as suggested by Stephen B.
>    - Removed unnecessary parens spotted by Stephen B.
>    - in general some cleanup done.
>
> Changes since RFC:
>     - Moved qcom_dml.* to mmci_qcom_dml.* as suggested by Linus W.
>     - added BAM DMA dependency in Kconfig as suggested by Linus W

I really like this v2 version.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
