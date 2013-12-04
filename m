Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab3LDCqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:46:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:32520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab3LDCqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:46:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,821,1378882800"; 
   d="scan'208";a="446425294"
Date: Tue, 3 Dec 2013 18:44:52 -0800
From: "David E. Box" <david.e.box@linux.intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCHv2 2/2] ACPI/platform: Add ACPI ID for Intel MBI device
Message-ID: <20131204024452.GB8282@linux.intel.com>
References: <1385100357-5459-1-git-send-email-david.e.box@linux.intel.com>
 <1386115178-7559-1-git-send-email-david.e.box@linux.intel.com>
 <1386115178-7559-3-git-send-email-david.e.box@linux.intel.com>
 <20131204013001.GA25037@srcf.ucam.org>
 <20131204021703.GA8282@linux.intel.com>
 <20131204022130.GA26084@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204022130.GA26084@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 02:21:30AM +0000, Matthew Garrett wrote:
> On Tue, Dec 03, 2013 at 06:17:03PM -0800, David E. Box wrote:
> > This is per the requirement in Documentation/acpi/enumeration.txt:
> > 
> > "Currently the kernel is not able to automatically determine from which ACPI
> > device it should make the corresponding platform device so we need to add
> > the ACPI device explicitly to acpi_platform_device_ids list defined in
> > drivers/acpi/acpi_platform.c"
> 
> Well sure, but why do you need to be a platform device at all? This 
> functionality was intended for cases where we already have a driver for 
> the part that enumerated it via some other mechanism. If the driver's 
> only intended for ACPI systems then why not just be an ACPI device?
> 

It was my understanding that with ACPI 5.0 it was becoming more common to use
ACPI ID's exclusively for device enumeration. I originally wrote this as an
acpi_bus driver but Rafeal advised me that the model is being phased out and
suggeted the platform model instead.

> -- 
> Matthew Garrett | mjg59@srcf.ucam.org
