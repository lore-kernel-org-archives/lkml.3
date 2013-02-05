Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3BEIT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:19:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:48485 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab3BEIT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:19:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="286686296"
Date: Tue, 5 Feb 2013 09:19:24 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: qingx@marvell.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        cxie4@marvell.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, patches@linaro.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH 1/6] mfd: max8925: add irqdomain for dt
Message-ID: <20130205081924.GM8476@sortiz-mobl>
References: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Mon, Feb 04, 2013 at 11:40:42PM +0800, Haojian Zhuang wrote:
> From: Qing Xu <qingx@marvell.com>
> 
> Add irqdomains for max8925's main irq, wrap irq register operations
> into irqdomain's map func. it is necessary for dt support.
> 
> Also, add dt support for max8925 driver.
> 
> Signed-off-by: Qing Xu <qingx@marvell.com>
> Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
>  drivers/mfd/max8925-core.c  |   73 +++++++++++++++++++++++++------------------
>  drivers/mfd/max8925-i2c.c   |   36 +++++++++++++++++++--
>  include/linux/mfd/max8925.h |    3 +-
>  3 files changed, 78 insertions(+), 34 deletions(-)
This and the next 5 patches applied, thanks for the heads up.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
