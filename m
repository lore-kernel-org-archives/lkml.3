Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab3ENS51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:57:27 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:36459 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3ENS5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <1368550322-1045-3-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
	<1368550322-1045-3-git-send-email-jiang.liu@huawei.com>
Date: Tue, 14 May 2013 11:57:24 -0700
X-Google-Sender-Auth: FtPcWQnNtklBi6z5RHiRKtFELJc
Message-ID: <CAE9FiQXZ+3FLfRJQUr+oRGtOoczeNS2+MZvazC77F_TxpdpHBg@mail.gmail.com>
Subject: Re: [RFC PATCH v2, part 2 03/18] PCI, hotplug: use hotplug-safe
 iterators to walk PCI buses
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 9:51 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Enhance PCI hotplug drivers to use hotplug-safe iterators to walk
> PCI buses.
>
> In other words, replace pci_find_bus(), pci_find_next_bus() and
> pci_root_buses with pci_bus_exists(), pci_get_bus(), pci_get_next_bus()
> and pci_get_next_root_bus() etc.
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Masanari Iida <standby24x7@gmail.com>
> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> Cc: Toshi Kani <toshi.kani@hp.com>
> Cc: linux-pci@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/pci/hotplug-pci.c          | 2 +-
>  drivers/pci/hotplug/ibmphp_core.c  | 8 +++++---
>  drivers/pci/hotplug/ibmphp_ebda.c  | 8 ++++++--
>  drivers/pci/hotplug/sgi_hotplug.c  | 3 ++-
>  drivers/pci/hotplug/shpchp_sysfs.c | 2 +-
>  5 files changed, 15 insertions(+), 8 deletions(-)

Acked-by: Yinghai Lu <yinghai@kernel.org>
