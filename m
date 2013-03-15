Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3COGpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 02:45:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:15571 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab3COGpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 02:45:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,849,1355126400"; 
   d="scan'208";a="215023165"
Date: Fri, 15 Mar 2013 07:44:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Axel Lin <axel.lin@ingics.com>
Subject: Re: [PATCH 2/3] mfd: Make AB8500_CORE select POWER_SUPPLY to fix
 build error
Message-ID: <20130315064436.GD12559@zurbaran>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
 <1363298204-8014-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363298204-8014-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Mar 14, 2013 at 10:56:39PM +0100, Arnd Bergmann wrote:
> From: Axel Lin <axel.lin@ingics.com>
> 
> This patch fixes below build error when CONFIG_POWER_SUPPLY is not set.
> 
> drivers/built-in.o: In function `ab8500_power_off':
> drivers/mfd/ab8500-sysctrl.c:37: undefined reference to `power_supply_get_by_name'
> drivers/mfd/ab8500-sysctrl.c:53: undefined reference to `power_supply_get_by_name'
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Please apply to MFD tree for 3.9
Already applied to mfd-fixes.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
