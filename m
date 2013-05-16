Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3EPWQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:16:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:38760 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab3EPWQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:16:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="303637180"
Date: Fri, 17 May 2013 00:16:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: wm8994: Emulate level triggered interrupts if
 required
Message-ID: <20130516221624.GQ22822@zurbaran>
References: <1367853176-31886-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367853176-31886-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, May 06, 2013 at 04:12:56PM +0100, Mark Brown wrote:
> The interrupt controller on the wm8994 series of devices requires a level
> triggered parent. If one is not available but a GPIO is available for the
> interrupt then emulate.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8994-irq.c         |  100 ++++++++++++++++++++++++++++++++++++--
>  include/linux/mfd/wm8994/core.h  |    2 +
>  include/linux/mfd/wm8994/pdata.h |    5 ++
>  3 files changed, 103 insertions(+), 4 deletions(-)
Applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
