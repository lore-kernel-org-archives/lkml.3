Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaAUJiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:38:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:51562 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871AbaAUJiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:38:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,695,1384329600"; 
   d="scan'208";a="468254700"
Date: Tue, 21 Jan 2014 11:45:13 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH] ACPI / PM: Use ACPI_COMPANION() to get ACPI companions
 of devices
Message-ID: <20140121094513.GK18029@intel.com>
References: <3698474.jasU9n7YCg@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3698474.jasU9n7YCg@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 04:38:33PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The ACPI device PM code in device_pm.c uses a special function,
> acpi_dev_pm_get_node(), to obtain an ACPI companion object of a given
> device.  However, that is not necessary any more after recent changes
> that introduced the ACPI_COMPANION() macro serving exactly the same
> purpose, but working in a much more straightforward way.  For this
> reason, drop acpi_dev_pm_get_node() and use ACPI_COMPANION() instead
> of it everywhere.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
