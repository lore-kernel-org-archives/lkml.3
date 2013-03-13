Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab3CMIfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:35:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:9645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab3CMIe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:34:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,834,1355126400"; 
   d="scan'208";a="278057072"
Date: Wed, 13 Mar 2013 09:34:53 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Make AB8500_CORE select POWER_SUPPLY to fix build
 error
Message-ID: <20130313083453.GB21994@zurbaran>
References: <1361287233.23734.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361287233.23734.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Feb 19, 2013 at 11:20:33PM +0800, Axel Lin wrote:
> This patch fixes below build error when CONFIG_POWER_SUPPLY is not set.
> 
> drivers/built-in.o: In function `ab8500_power_off':
> drivers/mfd/ab8500-sysctrl.c:37: undefined reference to `power_supply_get_by_name'
> drivers/mfd/ab8500-sysctrl.c:53: undefined reference to `power_supply_get_by_name'
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/mfd/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
Applied to my mfd-fixes tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
