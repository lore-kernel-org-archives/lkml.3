Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaFKJQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:16:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:24181 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbaFKJQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:16:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,457,1400050800"; 
   d="scan'208";a="555622211"
Date: Wed, 11 Jun 2014 12:16:36 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] ACPI / hotplug / PCI: Add hotplug contexts to PCI host
 bridges
Message-ID: <20140611091636.GB1657@lahna.fi.intel.com>
References: <1986515.ZPZrccsmiq@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1986515.ZPZrccsmiq@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 10:51:51PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After relatively recent changes in the ACPI-based PCI hotplug
> (ACPIPHP) code, the acpiphp_check_host_bridge() executed for PCI
> host bridges via acpi_pci_root_scan_dependent() doesn't do anything
> useful, because those bridges do not have hotplug contexts.  That
> happens by mistake, so fix it by making acpiphp_enumerate_slots()
> add hotplug contexts to PCI host bridges too and modify
> acpiphp_remove_slots() to drop those contexts for host bridges
> as appropriate.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=76901
> Fixes: 2d8b1d566a5f (ACPI / hotplug / PCI: Get rid of check_sub_bridges())
> Reported-and-tested-by: Gavin Guo <gavin.guo@canonical.com>
> Cc: 3.15+ <stable@vger.kernel.org> # 3.15+
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks for taking care of this!
