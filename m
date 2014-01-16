Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaAPMv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:51:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:47489 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbaAPMvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:51:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,667,1384329600"; 
   d="scan'208";a="467637441"
Message-ID: <1389876709.3010.6.camel@rzhang1-mobl4>
Subject: Re: [PATCH 3/4] fix module autoloading for ACPI enumerated devices
From: Zhang Rui <rui.zhang@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        wsa@the-dreams.de, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, jarkko.nikula@linux.intel.com,
        mika.westerberg@linux.intel.com
Date: Thu, 16 Jan 2014 20:51:49 +0800
In-Reply-To: <20140116122819.GO15567@sirena.org.uk>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
	 <1389689198-2641-4-git-send-email-rui.zhang@intel.com>
	 <20140116122819.GO15567@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 12:28 +0000, Mark Brown wrote:
> On Tue, Jan 14, 2014 at 04:46:37PM +0800, Zhang Rui wrote:
> > ACPI enumerated devices has ACPI style _HID and _CID strings,
> > all of these strings can be used for both driver loading and matching.
> > 
> > Currently, in Platform, I2C and SPI bus, the ACPI style driver matching
> > is supported by invoking acpi_driver_match_device() in bus .match() callback.
> > But, the module autoloading is still broken.
> 
> Acked-by: Mark Brown <broonie@linaro.org>
> 
> modulo the PAGE_SIZE stuff Mika noted - unless this changes radically
> please just assume I'm OK with it.

thanks.

-rui


