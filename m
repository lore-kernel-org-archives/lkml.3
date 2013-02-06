Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab3BFVxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:53:54 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:40261 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab3BFVxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:53:52 -0500
MIME-Version: 1.0
In-Reply-To: <52330506.F9m0tMYuG1@vostro.rjw.lan>
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com>
	<CAErSpo5-6xs+Uz=Yzws23RmrFK=+AQZ2=UT+n0k=462EgazbUA@mail.gmail.com>
	<CAE9FiQX=uEPjHDi-_VaW88ueH4u9C22gmDiGQewsQ=VN5T4=Gg@mail.gmail.com>
	<52330506.F9m0tMYuG1@vostro.rjw.lan>
Date: Wed, 6 Feb 2013 13:53:50 -0800
X-Google-Sender-Auth: YiK_7X4zFqsiFA4SwnCYT_7OwqM
Message-ID: <CAE9FiQXTRaP08ZeHWTJHt50DZO800BMigmo=q65-RLzZWkTvoQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] PCI: Iterate pci host bridge instead of pci root bus
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 1:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, February 06, 2013 01:28:27 PM Yinghai Lu wrote:
>> so you still did not answer you want 1 or 2 yet:
>>
>> for sgi_hotplug,
>>
>> 1. still keep the module support, and register acpi_pci_driver later.
>> 2. built-in support only, and need to register acpi_pci_driver early.
>
> Please work with the assumption that acpi_pci_driver is not going to be there
> any more.
>

I think I could change ioapic and iommu hotplug to weak add/remove because they
should be built-in by nature.

but how about others like sgi_hotplug etc?

Thanks

Yinghai
