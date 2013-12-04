Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab3LDCSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:18:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:16733 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab3LDCS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:18:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,821,1378882800"; 
   d="scan'208";a="418955761"
Date: Tue, 3 Dec 2013 18:17:03 -0800
From: "David E. Box" <david.e.box@linux.intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCHv2 2/2] ACPI/platform: Add ACPI ID for Intel MBI device
Message-ID: <20131204021703.GA8282@linux.intel.com>
References: <1385100357-5459-1-git-send-email-david.e.box@linux.intel.com>
 <1386115178-7559-1-git-send-email-david.e.box@linux.intel.com>
 <1386115178-7559-3-git-send-email-david.e.box@linux.intel.com>
 <20131204013001.GA25037@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204013001.GA25037@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 01:30:01AM +0000, Matthew Garrett wrote:
> On Tue, Dec 03, 2013 at 03:59:38PM -0800, David E. Box wrote:
> > From: "David E. Box" <david.e.box@linux.intel.com>
> > 
> > Adds ACPI ID for Intel IOSF-SB MailBox device found in BayTrail platforms.
> 
> Little bit confused here. This is a new driver and only declares 
> modaliases for the ACPI IDs - why does it need to be added here?
> 

This is per the requirement in Documentation/acpi/enumeration.txt:

"Currently the kernel is not able to automatically determine from which ACPI
device it should make the corresponding platform device so we need to add
the ACPI device explicitly to acpi_platform_device_ids list defined in
drivers/acpi/acpi_platform.c"

Without adding the device here it would not be discovered and probe would not be
called during init.

David Box

> -- 
> Matthew Garrett | mjg59@srcf.ucam.org
