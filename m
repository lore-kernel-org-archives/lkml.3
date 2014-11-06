Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaKFG0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 01:26:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:23866 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaKFG0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 01:26:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,324,1413270000"; 
   d="scan'208";a="632425766"
Date: Thu, 6 Nov 2014 11:56:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: swarren@wwwdotorg.org, dan.j.williams@intel.com, ldewangan@nvidia.com,
        thierry.reding@gmail.com, dmaengine@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, kiran.padwal21@gmail.com
Subject: Re: [PATCH 2/5] DMA: Remove .owner field for driver
Message-ID: <20141106062657.GU1870@intel.com>
References: <1411540764-27571-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411540764-27571-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:09:23PM +0530, Kiran Padwal wrote:
> There is no need to init .owner field.
> 
> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
> "mmc: remove .owner field for drivers using module_platform_driver"
> 
> This patch removes the superflous .owner field for drivers which
> use the module_platform_driver API, as this is overriden in
> platform_driver_register anyway."

Please make sure you use right subsytem name in patches

Applied with name fix

-- 
~Vinod
