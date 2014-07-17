Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbaGQTlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:41:16 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61442 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbaGQTlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:41:09 -0400
Message-ID: <53C826D1.1020609@linaro.org>
Date: Thu, 17 Jul 2014 20:41:05 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-mmc@vger.kernel.org
CC: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        agross@codeaurora.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1] mmc: mmci: Add qcom dml support to the driver.
References: <1405079306-1406-1-git-send-email-srinivas.kandagatla@linaro.org> <1405625780-13503-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1405625780-13503-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 17/07/14 20:36, Srinivas Kandagatla wrote:
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
> Tested-by: Prakash Burla <prakash.burla@smartplayin.com>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---

Here is the change log which I forgot in the original patch

Changes since RFC:
	- Moved	qcom_dml.* to mmci_qcom_dml.* as suggested by Linus W.
	- added BAM DMA dependency in Kconfig as suggested by Linus W
	


>   drivers/mmc/host/Kconfig         |  11 +++
>   drivers/mmc/host/Makefile        |   1 +
>   drivers/mmc/host/mmci.c          |  19 ++++-
>   drivers/mmc/host/mmci_qcom_dml.c | 171 +++++++++++++++++++++++++++++++++++++++
>   drivers/mmc/host/mmci_qcom_dml.h |  17 ++++
>   5 files changed, 218 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/mmc/host/mmci_qcom_dml.c
>   create mode 100644 drivers/mmc/host/mmci_qcom_dml.h
>


thanks,
srini
