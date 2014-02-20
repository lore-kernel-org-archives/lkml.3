Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaBTO0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:26:45 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:41442 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaBTO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:26:43 -0500
Date: Thu, 20 Feb 2014 09:26:39 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>
Subject: Re: [Update][PATCH 6/9] ACPI / ATA: Add hotplug contexts to ACPI
 companions of SATA devices
Message-ID: <20140220142639.GD6897@htj.dyndns.org>
References: <3011875.q18rCmXyYX@vostro.rjw.lan>
 <1707532.0BItEHDuFB@vostro.rjw.lan>
 <5317534.79aoyQFAO7@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5317534.79aoyQFAO7@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 02:47:19AM +0100, Rafael J. Wysocki wrote:
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
> ---
> 
> As noted by Aaron, the hotplug contexts are not freed during ATA device
> unregistration, but that is not necessary, because the struct acpi_device
> things they are attached to never go away.  However, they obviously should
> not be created more than once per struct acpi_device, so I've modified the
> patch to skip the creation of hotplug contexts for devices that already
> have them.

Please feel free to route with the rest of acpi changes.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
