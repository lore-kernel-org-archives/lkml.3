Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaIOTGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:06:44 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62931 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbaIOTGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:06:42 -0400
MIME-Version: 1.0
Reply-To: rajatxjain@gmail.com
In-Reply-To: <alpine.DEB.2.00.1409151152400.28050@skynet.skynet.ie>
References: <20140911222022.16809.57079.stgit@bhelgaas-glaptop2.roam.corp.google.com>
	<1434331.0IZIM5O2Ci@vostro.rjw.lan>
	<alpine.DEB.2.00.1409151152400.28050@skynet.skynet.ie>
Date: Mon, 15 Sep 2014 12:06:42 -0700
Message-ID: <CAA93t1qEmGkVHOJFjvB3OGecjC3c43SmpJW2yKv-OZTDESBWDw@mail.gmail.com>
Subject: Re: [PATCH 0/2] PCI: Ignore hotplug events for dual GPU systems
From: Rajat Jain <rajatxjain@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        SpacemanSpiff <a818958@trbvm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        "Jose P." <lbdkmjdf@sharklasers.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 3:53 AM, Dave Airlie <airlied@linux.ie> wrote:
>
>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Acked-by: Dave Airlie <airlied@redhat.com>

Acked-by: Rajat Jain <rajatxjain@gmail.com>

>>
>> for both.
>>
>> > ---
>> >
>> > Bjorn Helgaas (2):
>> >       PCI: Add pci_ignore_hotplug() to ignore hotplug events for a device
>> >       ACPIPHP / radeon / nouveau: Remove acpi_bus_no_hotplug()
>> >
>> >
>> >  drivers/acpi/bus.c                           |   10 ----------
>> >  drivers/gpu/drm/nouveau/nouveau_acpi.c       |   16 ++--------------
>> >  drivers/gpu/drm/nouveau/nouveau_drm.c        |    1 +
>> >  drivers/gpu/drm/radeon/radeon_atpx_handler.c |   16 ++--------------
>> >  drivers/gpu/drm/radeon/radeon_drv.c          |    1 +
>> >  drivers/pci/hotplug/acpiphp_glue.c           |   16 ++++++----------
>> >  drivers/pci/hotplug/pciehp_hpc.c             |   12 ++++++++++++
>> >  include/acpi/acpi_bus.h                      |    4 +---
>> >  include/linux/pci.h                          |    6 ++++++
>> >  9 files changed, 31 insertions(+), 51 deletions(-)
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
