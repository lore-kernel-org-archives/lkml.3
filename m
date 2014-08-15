Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaHOI0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 04:26:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:63263 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbaHOI0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 04:26:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,868,1400050800"; 
   d="scan'208";a="577072801"
Date: Fri, 15 Aug 2014 11:25:52 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, torvalds@linux-foundation.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] I2C: Rework kernel config I2C_ACPI
Message-ID: <20140815082552.GS2462@lahna.fi.intel.com>
References: <20140814093743.GB2824@katana>
 <1408081139-6292-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408081139-6292-1-git-send-email-tianyu.lan@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 01:38:59PM +0800, Lan Tianyu wrote:
> Commit da3c6647(I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI
> config) adds a new kernel config I2C_ACPI and make I2C core built in
> when the config is selected. This is wrong because distributions
> etc generally compile I2C as a module and the commit broken that.
> This patch is to rename I2C_ACPI to ACPI_I2C_OPREGION. New config
> only controls ACPI I2C operation region code and depends on I2C=y.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
