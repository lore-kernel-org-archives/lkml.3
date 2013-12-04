Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3LDBaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:30:08 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40969 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3LDBaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:30:06 -0500
Date: Wed, 4 Dec 2013 01:30:01 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCHv2 2/2] ACPI/platform: Add ACPI ID for Intel MBI device
Message-ID: <20131204013001.GA25037@srcf.ucam.org>
References: <1385100357-5459-1-git-send-email-david.e.box@linux.intel.com>
 <1386115178-7559-1-git-send-email-david.e.box@linux.intel.com>
 <1386115178-7559-3-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386115178-7559-3-git-send-email-david.e.box@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 03:59:38PM -0800, David E. Box wrote:
> From: "David E. Box" <david.e.box@linux.intel.com>
> 
> Adds ACPI ID for Intel IOSF-SB MailBox device found in BayTrail platforms.

Little bit confused here. This is a new driver and only declares 
modaliases for the ACPI IDs - why does it need to be added here?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
