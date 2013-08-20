Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab3HTBB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:01:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:6677 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab3HTBB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:01:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,915,1367996400"; 
   d="scan'208";a="284097721"
Date: Tue, 20 Aug 2013 03:01:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-omap@vger.kernel.org,
        Ruslan Bilovol <ruslan.bilovol@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mfd: twl6030-irq: rework and add twl6032 support
Message-ID: <20130820010154.GB13324@zurbaran>
References: <1374758151-12097-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374758151-12097-1-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

On Thu, Jul 25, 2013 at 04:15:46PM +0300, Grygorii Strashko wrote:
> This patch series intorduces twl6030-irq module rework to use Threaded IRQ and
> linear irq_domain, and adds support for PMIC TWL6032 IRQs.
> 
> After this patch series TWL6030/6032 IRQs will be supported only for DT boot mode.
> 
> Changes since v1:
> - Added new patch "mfd: twl6030-irq: create struct twl6030_irq" 
>   which introduces "struct twl6030_irq" to store all local variables inside it.
> - Patch "mfd: twl6030-irq: migrate to IRQ threaded handler":
>   Minor comments applied; fixed twl6030_exit_irq();
>   The Parent IRQ has been set for each nested IRQ.
> - Patch "mfd: twl6030-irq: convert to use linear irq_domain":
>   The irq_find_mapping() is used in twl6030_mmc_card_detect_config()
>   to get virtual IRQ number.
This looks good to me. Kevin, Graeme, any further comments/ACKs ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
