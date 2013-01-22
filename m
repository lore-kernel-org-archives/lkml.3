Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3AVD0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:26:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:6524 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3AVD0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:26:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="250508619"
Date: Tue, 22 Jan 2013 04:26:34 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3/4] pinctrl: add abx500 pinctrl driver core
Message-ID: <20130122032634.GM7409@sortiz-mobl>
References: <1358242984-5160-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358242984-5160-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Jan 15, 2013 at 10:43:04AM +0100, Linus Walleij wrote:
> From: Patrice Chotard <patrice.chotard@st.com>
> 
> This adds the AB8500 core driver, which will be utilized by
> the follow-on drivers for different ABx500 variants.
> Sselect the driver from the DBX500_SOC, as this chip is
> powering and clocking that SoC.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Hi Sam, it'd be great if you could ACK this so we could proceed
> with rewriting the GPIO driver.
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
