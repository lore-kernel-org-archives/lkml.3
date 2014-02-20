Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaBTIXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:23:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:40451 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaBTIXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:23:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,511,1389772800"; 
   d="scan'208";a="484669214"
Message-ID: <5305BB8B.30109@intel.com>
Date: Thu, 20 Feb 2014 16:23:39 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
CC: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [Update][PATCH 6/9] ACPI / ATA: Add hotplug contexts to ACPI
 companions of SATA devices
References: <3011875.q18rCmXyYX@vostro.rjw.lan> <1707532.0BItEHDuFB@vostro.rjw.lan> <5317534.79aoyQFAO7@vostro.rjw.lan>
In-Reply-To: <5317534.79aoyQFAO7@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 09:47 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Modify the SATA subsystem to add hotplug contexts to ACPI companions
> of SATA devices and ports instead of registering special ACPI dock
> operations using register_hotplug_dock_device().
> 
> That change will allow the entire code handling those special ACPI
> dock operations to be dropped in the next commit.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Aaron Lu <aaron.lu@intel.com>
