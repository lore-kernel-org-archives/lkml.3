Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab3BFV66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:58:58 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:54230 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab3BFV6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:58:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/22] PCI: Iterate pci host bridge instead of pci root bus
Date: Wed, 06 Feb 2013 23:05:14 +0100
Message-ID: <3459136.QID0qrXQHt@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQXTRaP08ZeHWTJHt50DZO800BMigmo=q65-RLzZWkTvoQ@mail.gmail.com>
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com> <52330506.F9m0tMYuG1@vostro.rjw.lan> <CAE9FiQXTRaP08ZeHWTJHt50DZO800BMigmo=q65-RLzZWkTvoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 06, 2013 01:53:50 PM Yinghai Lu wrote:
> On Wed, Feb 6, 2013 at 1:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, February 06, 2013 01:28:27 PM Yinghai Lu wrote:
> >> so you still did not answer you want 1 or 2 yet:
> >>
> >> for sgi_hotplug,
> >>
> >> 1. still keep the module support, and register acpi_pci_driver later.
> >> 2. built-in support only, and need to register acpi_pci_driver early.
> >
> > Please work with the assumption that acpi_pci_driver is not going to be there
> > any more.
> >
> 
> I think I could change ioapic and iommu hotplug to weak add/remove because they
> should be built-in by nature.
> 
> but how about others like sgi_hotplug etc?

I'd really prefer to wait for the patchset removing acpi_pci_driver (from
Myron) before proceeding with more changes in that area.

Myron, do you have a prototype based on the current linux-next?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
