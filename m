Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3AZXlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 18:41:40 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57895 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab3AZXli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 18:41:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7-XabKQh_Lia9zS9i4Mm=eBV6rRw0ArjXAZBiWYx4uYA@mail.gmail.com>
References: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
	<2072996.JYmST9orI6@vostro.rjw.lan>
	<CAE9FiQUS56KnvDCF7LUyCkNLcun+3zZ+xGiexca2ej30dRvrQg@mail.gmail.com>
	<CAErSpo7-XabKQh_Lia9zS9i4Mm=eBV6rRw0ArjXAZBiWYx4uYA@mail.gmail.com>
Date: Sat, 26 Jan 2013 15:34:09 -0800
X-Google-Sender-Auth: C6SOniwRmPfLCQXyZtWqoa9Sbxg
Message-ID: <CAE9FiQUhrVPNKcdWbiqHLa5PzH7Dg-uduVc9BP-OjM-eCqSXdw@mail.gmail.com>
Subject: Re: [PATCH v10 00/11] PCI, ACPI: pci root bus hotplug support / pci match_driver
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 4:04 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Jan 22, 2013 at 3:19 PM, Yinghai Lu <yinghai@kernel.org> wrote:

> I first pulled in
> "git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
> acpi-scan" again (to pci/acpi-scan2), added your acks, Rafael, and put
> this series on a pci/yinghai-root-bus branch based on pci/acpi-scan2.
>
> I reworked some of the changelogs a bit, but I don't think I made any
> code changes except that in [10/11] I just inlined the
> pci_bus_attach_device() code rather than making a new function, since
> it's small, there's only one caller, and I didn't think we needed any
> more pci_* and pci_bus_* functions than we already have.
>
> Let me know if I messed anything up.

Great, thanks for lot.

After that hit pci/next, will send out

for-pci-for-each-host-bridge

and

for-pci-for-each-add-res.

Thanks

Yinghai
