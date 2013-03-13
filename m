Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3CMIiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:38:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:22520 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab3CMIiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:38:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,834,1355126400"; 
   d="scan'208";a="300779813"
Date: Wed, 13 Mar 2013 09:38:10 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps65912: Declare and use tps65912_irq_exit()
Message-ID: <20130313083809.GF21994@zurbaran>
References: <1362209150-4869-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362209150-4869-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sat, Mar 02, 2013 at 03:25:50PM +0800, Mark Brown wrote:
> Clean up interrupts on exit, silencing a sparse warning caused by
> tps65912_irq_exit() being defined but not prototyped as we go.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/tps65912-core.c  |    1 +
>  include/linux/mfd/tps65912.h |    1 +
>  2 files changed, 2 insertions(+)
Applied to my mfd-fixes tree, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
