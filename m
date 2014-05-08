Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaEHPAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:00:51 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:38619 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbaEHPAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:00:47 -0400
Date: Thu, 8 May 2014 11:00:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] ata: pata_at91 only works on sam9
Message-ID: <20140508150042.GD5229@htj.dyndns.org>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399560990-1402858-10-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 04:56:21PM +0200, Arnd Bergmann wrote:
> The smc driver used by pata_at91 is at91sam9 specific, so building
> this driver on another at91 platform results in this error:
> 
> ERROR: "sam9_smc_configure" [drivers/ata/pata_at91.ko] undefined!
> ERROR: "sam9_smc_write_mode" [drivers/ata/pata_at91.ko] undefined!
> ERROR: "sam9_smc_read_mode" [drivers/ata/pata_at91.ko] undefined!
> 
> This patch changes the Kconfig dependency to ensure it always works.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-ide@vger.kernel.org
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Applied to libata/for-3.15-fixes.

Thanks.

-- 
tejun
