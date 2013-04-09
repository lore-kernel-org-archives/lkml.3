Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936970Ab3DIIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:16:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:58339 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935028Ab3DIIQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:16:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,437,1363158000"; 
   d="scan'208";a="319576360"
Date: Tue, 9 Apr 2013 10:16:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] clk: add LP8788 clock driver
Message-ID: <20130409081648.GJ24058@zurbaran>
References: <A874F61F95741C4A9BA573A70FE3998F82E4AB29@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E4AB29@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milo,

On Thu, Apr 04, 2013 at 01:34:37AM +0000, Kim, Milo wrote:
> Patch v2.
>   (a) Remove unnecessary 'is_enabled()' operation code.
>   (b) Add CLK_IGNORE_UNUSED flag.
>   (c) Add clock device detection code : lp8788_is_clk_device_ready()
>       If the device is not ready, return as -ENODEV on loading the driver.
> 
> Patch v1.
>   Initial patch
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/clk/Kconfig        |    7 ++
>  drivers/clk/Makefile       |    1 +
>  drivers/clk/clk-lp8788.c   |  160 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/lp8788.c       |    2 +
>  include/linux/mfd/lp8788.h |    1 +
>  5 files changed, 171 insertions(+)
>  create mode 100644 drivers/clk/clk-lp8788.c
For the MFD part:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
