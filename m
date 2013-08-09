Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031215Ab3HIV1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 17:27:47 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34543 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031121Ab3HIV1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:27:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Myron Stowe <myron.stowe@gmail.com>
Cc: thomas.petazzoni@free-electrons.com, jgunthorpe@obsidianresearch.com,
        thierry.reding@avionic-design.de, swarren@wwwdotorg.org,
        linux@arm.linux.org.uk, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org,
        linux-pci <linux-pci@vger.kernel.org>,
        iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, mika.westerberg@linux.intel.com,
        Alex Williamson <alex.williamson@redhat.com>,
        Don Dutile <ddutile@redhat.com>, liuj97@gmail.com,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: Linux Plumbers ACPI/PM, PCI Microconference
Date: Fri, 09 Aug 2013 23:37:56 +0200
Message-ID: <19119445.uFrsn6yGJd@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAL-B5D1-CPNcOzjHx4ej5SenawvDqwC4Hef5oDkoxCb9Dz5dUw@mail.gmail.com>
References: <CAL-B5D1-CPNcOzjHx4ej5SenawvDqwC4Hef5oDkoxCb9Dz5dUw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 09, 2013 12:12:24 PM Myron Stowe wrote:
> Time is passing quickly and there are still a few topic areas that we
> would like discussed during the microconference but still do not have
> any proposals/knowledgable speakers for.
> 
> For the following people I'm specifically picking on: Are you going to
> plumbers, would you be willing to cover the following areas?  If you
> are not going, do you know someone who is and could cover?
> 
> Yinghai: host bridge hot-plug - what has been accomplished to date and
> what still remains to be done?
> 
> Mika: Thunderbolt activities?

That falls under my hotplug topic (that's been submitted already).

> Jiang Liu, Gu Zheng: Would you be willing to cover your recent efforts
> with PCI device (hot-plug) reference counting?
> 
> Russel, Rob, Stephen, Thomas, Jason, Thierry: ARM - especially any
> PCI(e) ideosynchronicies along with ARM's IOMMU arch and how that
> relates to PCI.
> 
> Alex Williamson: you want/need to cover any of the following - PCI
> secondary bus resets; pci_is_pcie() - Not just for PCIe capabilities;
> I/O port pci-sysfs resource files (fix or remove)?
> 
> Of course anyone else is free to propose something or sign up for
> covering one of the proposed topics listed at
> http://wiki.linuxplumbersconf.org/2013:pci_subsystem
> 
> 
> The instructions for submitting proposals should be at:
> 
> http://www.linuxplumbersconf.org/2013/submitting-topic/
> 
> The Microconference link is at:
> 
> http://wiki.linuxplumbersconf.org/2013:pci_subsystem

Yes, everyone, if you are going to attend the LPC and have a topic for
discussion during the ACPI/PM+PCI uconf, please submit a proposal.

We should be able to accommodate 7-8 30-minutes slots.

Thanks,
Rafael

