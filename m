Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3LDCVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:21:35 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41656 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3LDCVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:21:32 -0500
Date: Wed, 4 Dec 2013 02:21:30 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCHv2 2/2] ACPI/platform: Add ACPI ID for Intel MBI device
Message-ID: <20131204022130.GA26084@srcf.ucam.org>
References: <1385100357-5459-1-git-send-email-david.e.box@linux.intel.com>
 <1386115178-7559-1-git-send-email-david.e.box@linux.intel.com>
 <1386115178-7559-3-git-send-email-david.e.box@linux.intel.com>
 <20131204013001.GA25037@srcf.ucam.org>
 <20131204021703.GA8282@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204021703.GA8282@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 06:17:03PM -0800, David E. Box wrote:
> This is per the requirement in Documentation/acpi/enumeration.txt:
> 
> "Currently the kernel is not able to automatically determine from which ACPI
> device it should make the corresponding platform device so we need to add
> the ACPI device explicitly to acpi_platform_device_ids list defined in
> drivers/acpi/acpi_platform.c"

Well sure, but why do you need to be a platform device at all? This 
functionality was intended for cases where we already have a driver for 
the part that enumerated it via some other mechanism. If the driver's 
only intended for ACPI systems then why not just be an ACPI device?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
