Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaHRGXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:23:49 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61554 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaHRGXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:23:47 -0400
Message-ID: <53F19BE7.6070300@linaro.org>
Date: Mon, 18 Aug 2014 07:23:35 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>, Vinod Koul <vinod.koul@intel.com>
CC: devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH 0/2] dmaengine: qcom_bam_dma: Add support for v1.3.0
References: <1397684719-30065-1-git-send-email-agross@codeaurora.org>
In-Reply-To: <1397684719-30065-1-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,
Any plans to respin these patches with Stanimir's comments?

thanks,
srini


On 16/04/14 22:45, Andy Gross wrote:
> This set of patches adds support for the v1.3.0 version of the QCOM BAM
> dmaengine driver.  The older version of the BAM is present in the MSM8x64,
> APQ8064, and IPQ8064 processors.
>
> Due to register address space changes between versions, all of the register
> accesses have to be calculated using different offsets and multipliers that are
> specific to that version of the IP block.
>
> Andy Gross (2):
>    dmaengine: qcom_bam_dma: Add v1.3.0 driver support
>    dmaengine: qcom_bam_dma: Add binding for v1.3.0
>
>   .../devicetree/bindings/dma/qcom_bam_dma.txt       |    4 +-
>   drivers/dma/qcom_bam_dma.c                         |  177 +++++++++++++-------
>   2 files changed, 117 insertions(+), 64 deletions(-)
>
