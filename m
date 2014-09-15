Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaIOKxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:53:10 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60290 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbaIOKxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:53:07 -0400
Date: Mon, 15 Sep 2014 11:53:03 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        SpacemanSpiff <a818958@trbvm.com>, Rajat Jain <rajatxjain@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        "Jose P." <lbdkmjdf@sharklasers.com>
Subject: Re: [PATCH 0/2] PCI: Ignore hotplug events for dual GPU systems
In-Reply-To: <1434331.0IZIM5O2Ci@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.00.1409151152400.28050@skynet.skynet.ie>
References: <20140911222022.16809.57079.stgit@bhelgaas-glaptop2.roam.corp.google.com> <1434331.0IZIM5O2Ci@vostro.rjw.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Dave Airlie <airlied@redhat.com>
> 
> for both.
> 
> > ---
> > 
> > Bjorn Helgaas (2):
> >       PCI: Add pci_ignore_hotplug() to ignore hotplug events for a device
> >       ACPIPHP / radeon / nouveau: Remove acpi_bus_no_hotplug()
> > 
> > 
> >  drivers/acpi/bus.c                           |   10 ----------
> >  drivers/gpu/drm/nouveau/nouveau_acpi.c       |   16 ++--------------
> >  drivers/gpu/drm/nouveau/nouveau_drm.c        |    1 +
> >  drivers/gpu/drm/radeon/radeon_atpx_handler.c |   16 ++--------------
> >  drivers/gpu/drm/radeon/radeon_drv.c          |    1 +
> >  drivers/pci/hotplug/acpiphp_glue.c           |   16 ++++++----------
> >  drivers/pci/hotplug/pciehp_hpc.c             |   12 ++++++++++++
> >  include/acpi/acpi_bus.h                      |    4 +---
> >  include/linux/pci.h                          |    6 ++++++
> >  9 files changed, 31 insertions(+), 51 deletions(-)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
