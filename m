Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaAOOzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:55:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:12386 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbaAOOzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:55:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,663,1384329600"; 
   d="scan'208";a="467089176"
Date: Wed, 15 Jan 2014 17:02:45 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        wsa@the-dreams.de, broonie@linaro.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, jarkko.nikula@linux.intel.com
Subject: Re: [PATCH 1/4] ACPI: fix create_modalias() return value handling
Message-ID: <20140115150245.GW2494@intel.com>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
 <1389689198-2641-2-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389689198-2641-2-git-send-email-rui.zhang@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 04:46:35PM +0800, Zhang Rui wrote:
> Currently, create_modalias() handles the output truncated case in
> an improper way (return -EINVAL).
> Plus, acpi_device_uevent() and acpi_device_modalias_show() do
> improper check for the create_modalias() return value as well.
> 
> This patch fixes create_modalias() to
> return -EINVAL if there is an output error,
> return -ENOMEM if the output is truncated,
> and also fixes both acpi_device_uevent() and acpi_device_modalias_show()
> to do proper return value check.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
