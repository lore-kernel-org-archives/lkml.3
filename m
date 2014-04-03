Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaDCQmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:42:24 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:57282 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbaDCQmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:42:22 -0400
Message-ID: <533D8F6C.6000606@mm-sol.com>
Date: Thu, 03 Apr 2014 19:42:20 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [Patch v9 2/2] dmaengine: add Qualcomm BAM dma driver
References: <1394487622-1679-1-git-send-email-agross@codeaurora.org> <1394487622-1679-3-git-send-email-agross@codeaurora.org>
In-Reply-To: <1394487622-1679-3-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 03/10/2014 11:40 PM, Andy Gross wrote:
> Add the DMA engine driver for the QCOM Bus Access Manager (BAM) DMA controller
> found in the MSM 8x74 platforms.
> 
> Each BAM DMA device is associated with a specific on-chip peripheral.  Each
> channel provides a uni-directional data transfer engine that is capable of
> transferring data between the peripheral and system memory (System mode), or
> between two peripherals (BAM2BAM).
> 
> The initial release of this driver only supports slave transfers between
> peripherals and system memory.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>

I tested this driver during wake up of the crypto driver. With your
additions to bam_start_dma() in regards to EOT interrupts I successfully
passed the crypto framework test vectors for the implemented algorithms.

Tested-by: Stanimir Varbanov <svarbanov@mm-sol.com>

regards,
Stan
