Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab3ENSzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:55:19 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46901 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3ENSzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:55:17 -0400
MIME-Version: 1.0
In-Reply-To: <1368550322-1045-2-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
	<1368550322-1045-2-git-send-email-jiang.liu@huawei.com>
Date: Tue, 14 May 2013 11:55:16 -0700
X-Google-Sender-Auth: Cow6nmcsXrvA6hH8S0IJw1kqIlU
Message-ID: <CAE9FiQWoi3J=oZ6Y2DqAeorMgknBZ+LwbFXLz+hYo=GwavqU6w@mail.gmail.com>
Subject: Re: [RFC PATCH v2, part 2 02/18] PCI, core: use hotplug-safe
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
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Xen Devel <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 9:51 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Enhance PCI core to use hotplug-safe iterators to walk PCI buses.
>
> In other words, replace pci_find_bus(), pci_find_next_bus() and
> pci_root_buses with pci_bus_exists(), pci_get_bus(), pci_get_next_bus()
> and pci_get_next_root_bus() etc.

good changes.

Acked-by:  Yinghai Lu <yinghai@kernel.org>
