Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab3EOMEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:04:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:27741 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488Ab3EOMEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:04:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,677,1363158000"; 
   d="scan'208";a="241883991"
Message-ID: <1368619642.15764.96.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2 0/4] Export the ecc step size to user applications
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 15 May 2013 15:07:22 +0300
In-Reply-To: <1368607606-4344-1-git-send-email-b32955@freescale.com>
References: <1368607606-4344-1-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 16:46 +0800, Huang Shijie wrote:
> In order to implement the NAND boot for some Freescale's chips, such as
> imx23/imx28/imx50/imx6, we use a tool (called kobs-ng) to burn the uboot
> and some metadata to nand chip. And the ROM code will use the metadata to
> configrate the BCH, and to find the uboot.
> 
> The ECC information(ecc step size, ecc strength) which is used to configrate
> the BCH is part of the metadata. The kobs-ng can gets the ecc strength from
> the sys node /sys/*/mtdX/ecc_strength now. But it can't gets the ecc step size.

Looks good to me. Would you please update
Documentation/ABI/testing/sysfs-class-mtd as well?

-- 
Best Regards,
Artem Bityutskiy

