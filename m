Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625Ab3BIDmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 22:42:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:42360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab3BIDl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 22:41:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,632,1355126400"; 
   d="scan'208";a="260130083"
Date: Sat, 9 Feb 2013 05:45:51 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] Documentation / acpi: refer to correct file for
 acpi_platform_device_ids[] table
Message-ID: <20130209034551.GS20771@intel.com>
References: <1360332421-32140-1-git-send-email-mika.westerberg@linux.intel.com>
 <38872303.yk2lQjq1aC@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38872303.yk2lQjq1aC@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2013 at 12:14:27AM +0100, Rafael J. Wysocki wrote:
> On Friday, February 08, 2013 04:07:01 PM Mika Westerberg wrote:
> > When the ACPI platform device code was converted to the new ACPI scan
> > handler facility, the the acpi_platform_device_ids[] was moved to
> > drivers/acpi/acpi_platform.c. Update the documentation accordingly.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Applied.

Thanks!

> When you post any patches touching ACPI, please send CCs of them to
> linux-acpi as well.

Sure.

In this case I just CC'd what get_maintainer.pl gave me and somehow it
missed linux-acpi totally.
