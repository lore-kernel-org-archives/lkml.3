Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3AVD1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:27:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:64045 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636Ab3AVD1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:27:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="246822598"
Date: Tue, 22 Jan 2013 04:27:45 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 3/4] watchdog: add support for ux500_wdt watchdog
Message-ID: <20130122032745.GP7409@sortiz-mobl>
References: <1358509214-22407-1-git-send-email-fabio.baltieri@linaro.org>
 <1358509214-22407-4-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358509214-22407-4-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio, Wim,

On Fri, Jan 18, 2013 at 12:40:13PM +0100, Fabio Baltieri wrote:
> This patch adds support for the ux500_wdt watchdog that is found in
> ST-Ericsson Ux500 platform.  The driver is based on PRCMU APIs.
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  drivers/watchdog/Kconfig                |  12 +++
>  drivers/watchdog/Makefile               |   1 +
>  drivers/watchdog/ux500_wdt.c            | 171 ++++++++++++++++++++++++++++++++
>  include/linux/platform_data/ux500_wdt.h |  19 ++++
>  4 files changed, 203 insertions(+)
>  create mode 100644 drivers/watchdog/ux500_wdt.c
>  create mode 100644 include/linux/platform_data/ux500_wdt.h
There is a dependency between this one an the first patch.
Wim, would you like me to carry this patch through the MFD tree ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
