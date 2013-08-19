Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932Ab3HSGKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:10:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:33699 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab3HSGKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:10:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,911,1367996400"; 
   d="scan'208";a="389306765"
Date: Mon, 19 Aug 2013 09:16:14 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jerry Snitselaar <jerry.snitselaar@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH] acpi_i2c: set MODULE_LICENSE, MODULE_AUTHOR, and
 MODULE_DESCRIPTION
Message-ID: <20130819061614.GG4898@intel.com>
References: <1376702795-25912-1-git-send-email-jerry.snitselaar@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376702795-25912-1-git-send-email-jerry.snitselaar@oracle.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 06:26:35PM -0700, Jerry Snitselaar wrote:
> Without MODULE_LICENSE set, I get the following with modprobe:
> 
> acpi_i2c: module license 'unspecified' taints kernel.
> acpi_i2c: Unknown symbol i2c_new_device (err 0)
> acpi_i2c: Unknown symbol acpi_dev_get_resources (err 0)
> acpi_i2c: Unknown symbol acpi_dev_resource_interrupt (err 0)
> acpi_i2c: Unknown symbol acpi_dev_free_resource_list (err 0)
> 
> Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>

Looks good to me.

Acked-by: Mika Westerbeg <mika.westerberg@linux.intel.com>
