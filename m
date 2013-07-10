Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3GJOPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:15:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:48011 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab3GJOPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:15:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1036,1363158000"; 
   d="scan'208";a="367818855"
Date: Wed, 10 Jul 2013 17:20:15 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-designware: configure SDA hold time from ACPI
Message-ID: <20130710142015.GD4898@intel.com>
References: <1372845160-32625-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372845160-32625-1-git-send-email-mika.westerberg@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 12:52:40PM +0300, Mika Westerberg wrote:
> Some Intel LPSS I2C devices make the SDA hold time parameter available via
> SSCN (standard mode) and FMCN (fast mode) ACPI methods. If we find that
> such method exist, we evaluate it and pass the returned SDA hold value to
> the i2c-designware core analogous to Device Tree.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Please disregard this patch. I'll send a new one that combines both setting of
SDA hold time and *CNT values from ACPI.
