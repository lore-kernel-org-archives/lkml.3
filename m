Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3FTIYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:24:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:11157 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab3FTIYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:24:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,903,1363158000"; 
   d="scan'208";a="356599997"
Date: Thu, 20 Jun 2013 10:23:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lee.jones@linaro.org
Subject: Re: [PATCH 1/2] mfd: davinci_voicecodec: Fix build breakage
Message-ID: <20130620082338.GA15667@zurbaran>
References: <1371549940-18834-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371549940-18834-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Tue, Jun 18, 2013 at 03:35:39PM +0530, Sachin Kamat wrote:
> Include the missing header file to fix the following build error:
> drivers/mfd/davinci_voicecodec.c: In function ‘davinci_vc_probe’:
> drivers/mfd/davinci_voicecodec.c:86:3: error: implicit declaration of function
> ‘io_v2p’ [-Werror=implicit-function-declaration]
>    (dma_addr_t)(io_v2p(davinci_vc->base) + DAVINCI_VC_WFIFO);
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> This series is based on Samuel's mfd-next tree and is compile tested.
> ---
>  include/linux/mfd/davinci_voicecodec.h |    1 +
>  1 file changed, 1 insertion(+)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
