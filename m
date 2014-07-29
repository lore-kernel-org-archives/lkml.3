Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaG2RzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:55:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45423 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaG2RzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:55:17 -0400
Message-ID: <53D7E004.7080401@codeaurora.org>
Date: Tue, 29 Jul 2014 10:55:16 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: linux-mmc@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        agross@codeaurora.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v4] mmc: mmci: Add qcom dml support to the driver.
References: <1406528572-5749-1-git-send-email-srinivas.kandagatla@linaro.org> <1406602230-18542-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1406602230-18542-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/14 19:50, Srinivas Kandagatla wrote:
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
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

