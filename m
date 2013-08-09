Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab3HISMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:12:38 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:56216 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595Ab3HISMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:12:25 -0400
MIME-Version: 1.0
Date: Fri, 9 Aug 2013 12:12:24 -0600
Message-ID: <CAL-B5D1-CPNcOzjHx4ej5SenawvDqwC4Hef5oDkoxCb9Dz5dUw@mail.gmail.com>
Subject: Linux Plumbers ACPI/PM, PCI Microconference
From: Myron Stowe <myron.stowe@gmail.com>
To: thomas.petazzoni@free-electrons.com, jgunthorpe@obsidianresearch.com,
        thierry.reding@avionic-design.de, swarren@wwwdotorg.org,
        linux@arm.linux.org.uk, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org,
        linux-pci <linux-pci@vger.kernel.org>,
        iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, mika.westerberg@linux.intel.com,
        Alex Williamson <alex.williamson@redhat.com>,
        Don Dutile <ddutile@redhat.com>, liuj97@gmail.com,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Time is passing quickly and there are still a few topic areas that we
would like discussed during the microconference but still do not have
any proposals/knowledgable speakers for.

For the following people I'm specifically picking on: Are you going to
plumbers, would you be willing to cover the following areas?  If you
are not going, do you know someone who is and could cover?

Yinghai: host bridge hot-plug - what has been accomplished to date and
what still remains to be done?

Mika: Thunderbolt activities?

Jiang Liu, Gu Zheng: Would you be willing to cover your recent efforts
with PCI device (hot-plug) reference counting?

Russel, Rob, Stephen, Thomas, Jason, Thierry: ARM - especially any
PCI(e) ideosynchronicies along with ARM's IOMMU arch and how that
relates to PCI.

Alex Williamson: you want/need to cover any of the following - PCI
secondary bus resets; pci_is_pcie() - Not just for PCIe capabilities;
I/O port pci-sysfs resource files (fix or remove)?

Of course anyone else is free to propose something or sign up for
covering one of the proposed topics listed at
http://wiki.linuxplumbersconf.org/2013:pci_subsystem


The instructions for submitting proposals should be at:

http://www.linuxplumbersconf.org/2013/submitting-topic/

The Microconference link is at:

http://wiki.linuxplumbersconf.org/2013:pci_subsystem
