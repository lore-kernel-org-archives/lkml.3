Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3AVA2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:28:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:8302 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3AVA2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:28:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,510,1355126400"; 
   d="scan'208";a="193700112"
Date: Tue, 22 Jan 2013 01:28:33 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps65910: Select REGMAP_IRQ in Kconfig to fix build
 error
Message-ID: <20130122002833.GC7409@sortiz-mobl>
References: <1355138096-7702-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355138096-7702-1-git-send-email-anilkumar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anilkumar,

On Mon, Dec 10, 2012 at 04:44:56PM +0530, AnilKumar Ch wrote:
> TPS65910 mfd driver uses functions that are only avaiable when
> REGMAP_IRQ is enabled. So "select REGMAP_IRQ" is added to mfd
> Kconfig to fix below build error:
> 
> drivers/built-in.o: In function `tps65910_irq_exit':
> /media/anil/kernel/drivers/mfd/tps65910.c:265: undefined reference to `regmap_del_irq_chip'
> drivers/built-in.o: In function `tps65910_irq_init':
> /media/anil/kernel/drivers/mfd/tps65910.c:254: undefined reference to `regmap_add_irq_chip'
> drivers/built-in.o: In function `tps65910_i2c_probe':
> /media/anil/kernel/drivers/mfd/tps65910.c:509: undefined reference to `regmap_irq_get_domain'
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
> ---
>  drivers/mfd/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
Applied to my for-linus branch. Sorry for not carrying it with my 3.8 pull
request.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
