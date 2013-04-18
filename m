Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936725Ab3DRWky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 18:40:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:37841 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936708Ab3DRWkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:40:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,504,1363158000"; 
   d="scan'208";a="320571594"
Date: Fri, 19 Apr 2013 00:40:46 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Marek Vasut <marex@denx.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Jean Delvare <jdelvare@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] UCB1400: Pass ucb1400-gpio data through ac97 bus
Message-ID: <20130418224046.GD8798@zurbaran>
References: <CACRpkdZ+ku_-SBTXwwwRDh7F2TXzpgpAF3k+Ksn98BNYXximXw@mail.gmail.com>
 <1365964548-4193-1-git-send-email-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365964548-4193-1-git-send-email-marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 08:35:48PM +0200, Marek Vasut wrote:
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Jean Delvare <jdelvare@suse.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-kernel <linux-kernel@vger.kernel.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
>  drivers/gpio/gpio-ucb1400.c |   19 ++++++-------------
>  drivers/mfd/ucb1400_core.c  |    5 +++++
>  include/linux/ucb1400.h     |   18 ++++++------------
>  3 files changed, 17 insertions(+), 25 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
