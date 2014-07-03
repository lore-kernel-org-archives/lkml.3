Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbaGCPrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:47:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:54960 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbaGCPrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:47:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="359323779"
Message-ID: <53B57B23.4020607@linux.intel.com>
Date: Thu, 03 Jul 2014 23:47:47 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: chris@printf.net, ulf.hansson@linaro.org, jh80.chung@samsung.com,
        tgih.jun@samsung.com, aaron.lu@intel.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jackey.shen@amd.com,
        gregkh@linuxfoundation.org
Subject: One bug of SDHCI driver
References: <53B249A4.2040404@linux.intel.com>
In-Reply-To: <53B249A4.2040404@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, all

The statement "mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;" is added in "sdhci_add_host" function in host/sdhci.c file. In some cases, this will make  "host->sdio_irq_thread" a NULL pointer in "mmc_sdio_resume" functon of core/sdio.c file and lead to resume failure. Could you please give me some advice how to fix this bug?



Thanks,
Zhonghui





