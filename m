Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaHTHwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:52:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:30588 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaHTHwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:52:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,900,1400050800"; 
   d="scan'208";a="590644224"
Date: Wed, 20 Aug 2014 10:52:22 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: atull@opensource.altera.com
Cc: wsa@the-dreams.de, baruch@tkos.co.il, grant.likely@linaro.org,
        robh+dt@kernel.org, skuribay@pobox.com, Romain.Baeriswyl@abilis.com,
        rafael.j.wysocki@intel.com, alan@linux.intel.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH] i2c: designware: deduce speed mode from device tree
 setting
Message-ID: <20140820075222.GA1660@lahna.fi.intel.com>
References: <1408479529-24249-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408479529-24249-1-git-send-email-atull@opensource.altera.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 03:18:49PM -0500, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Use the documented, but unimplemented "clock-frequency"
> Device Tree setting as a guide on whether to set the speed
> mode bits in DW_IC_CON to standard or fast i2c mode.
> 
> Previously, the driver was hardwired to fast mode.  Default
> to fast mode if the "clock-frequency" property is not present
> for backwards compatiblity.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>

I don't know much about the Device Tree bindings but the patch looks
good to me,

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
