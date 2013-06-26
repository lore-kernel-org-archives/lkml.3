Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3FZTsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:48:45 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:44712 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3FZTsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:48:43 -0400
Date: Wed, 26 Jun 2013 13:48:39 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 0/6] Thunderbolt workarounds take 2
Message-ID: <20130626194839.GA30260@google.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <12066786.EK0Z2aX1JA@vostro.rjw.lan>
 <20130626072536.GN9294@intel.com>
 <3671062.GUfa7jqN3X@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3671062.GUfa7jqN3X@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 02:45:40PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, June 26, 2013 10:25:36 AM Mika Westerberg wrote:
> > On Wed, Jun 26, 2013 at 01:24:25AM +0200, Rafael J. Wysocki wrote:
> > > Would you please CC things touching ACPIPHP to linux-acpi?
> > 
> > Sorry about that -- It wasn't listed in the output of get_maintainers.pl so
> > it kind of was forgotten.
> > 
> > Do you want me to resend this series with linux-acpi@ included?
> 
> No need, just please remember about that in the future.

Maybe we should do the following?  That covers the following files under
drivers/pci:

    drivers/pci/hotplug/pciehp_acpi.c
    drivers/pci/hotplug/acpi_pcihp.c
    drivers/pci/hotplug/acpiphp_glue.c
    drivers/pci/hotplug/acpiphp_core.c
    drivers/pci/hotplug/acpiphp_ibm.c
    drivers/pci/pcie/aer/aerdrv_acpi.c
    drivers/pci/pcie/portdrv_acpi.c
    drivers/pci/pci-acpi.c


commit 961e3992849e18f9ed6cbcac5c54fb29925341b3
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Wed Jun 26 13:38:37 2013 -0600

    MAINTAINERS: Add ACPI folks for ACPI-related things under drivers/pci
    
    Add file patterns so get_maintainers.pl reports both PCI and ACPI folks
    for ACPI-related things in drivers/pci.
    
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d7782b..ce65550 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -242,6 +242,9 @@ F:	drivers/acpi/
 F:	drivers/pnp/pnpacpi/
 F:	include/linux/acpi.h
 F:	include/acpi/
+F:	drivers/pci/*acpi*
+F:	drivers/pci/*/*acpi*
+F:	drivers/pci/*/*/*acpi*
 
 ACPI FAN DRIVER
 M:	Zhang Rui <rui.zhang@intel.com>
