Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaH2J6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:58:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:28392 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaH2J6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:58:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,424,1406617200"; 
   d="scan'208";a="565270307"
Message-ID: <1409306274.30155.30.camel@linux.intel.com>
Subject: Re: [PATCH v1 0/5] mfd: lpc_sch: Intel Quark support
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Date: Fri, 29 Aug 2014 12:57:54 +0300
In-Reply-To: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 13:58 +0300, Andy Shevchenko wrote:
> This brings support of the LPC SCH device found on Intel Quark SoC. Patches
> were compile tested, and driver runs on actual hardware.
> 
> Please, note that PCI ID will be used in future in the gpio-sch driver.

Bjorn, could you Ack or comment patch 3/5?

Lee, do you have any comments on the series?

> 
> Andy Shevchenko (4):
>   mfd: lpc_sch: reduce duplicate code
>   mfd: lpc_sch: better code manageability with chipset info struct
>   mfd: lpc_sch: Add support for Intel Quark X1000
>   mfd: lpc_sch: remove FSF address
> 
> Josef Ahmad (1):
>   pci_ids: add support for Intel Quark ILB
> 
>  drivers/mfd/lpc_sch.c   | 207 ++++++++++++++++++++++++++++--------------------
>  include/linux/pci_ids.h |   1 +
>  2 files changed, 122 insertions(+), 86 deletions(-)
> 


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

