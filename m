Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab3BVJ3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:29:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:25138 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab3BVJ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:28:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,714,1355126400"; 
   d="scan'208";a="266136170"
Date: Fri, 22 Feb 2013 11:33:07 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] spi: fix return value check in ce4100_spi_probe()
Message-ID: <20130222093307.GH2439@intel.com>
References: <CAPgLHd-PhE2igUQOeg90H98Ni55DwfYdp0D52uaBK0=J3M1V+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-PhE2igUQOeg90H98Ni55DwfYdp0D52uaBK0=J3M1V+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 10:52:35AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function platform_device_register_full()
> returns ERR_PTR() and never returns NULL. The NULL test in the
> return value check should be replaced with IS_ERR().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Nice catch!

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
