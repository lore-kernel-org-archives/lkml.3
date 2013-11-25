Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3KYDRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 22:17:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:62383 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab3KYDRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 22:17:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,765,1378882800"; 
   d="scan'208";a="433059053"
Message-ID: <5292C158.7090508@intel.com>
Date: Mon, 25 Nov 2013 11:17:44 +0800
From: Aaron Lu <aaron.lu@intel.com>
Organization: Intel, Shanghai, PRC
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/4] ACPI / bind: Simplify child devices lookup
References: <2610478.KxPMyuOMok@vostro.rjw.lan>
In-Reply-To: <2610478.KxPMyuOMok@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 08:09 AM, Rafael J. Wysocki wrote:
> Hi,
> 
> The following series of four patches (on top of current linux-pm.git/bleeding-edge)
> rework child device lookup in drivers/acpi/glue.c and related things:
> 
> [1/4] ACPI / bind: Simplify child device lookup
> [2/4] PCI/ ACPI: Use acpi_find_child_device() for child device lookup
> [3/4] ACPI / bind: Redefine acpi_get_child()
> [4/4] ACPI / bind: Redefine acpi_preset_companion()
> 
> Thanks!
> 

Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Aaron Lu <aaron.lu@intel.com> #for ATA binding
