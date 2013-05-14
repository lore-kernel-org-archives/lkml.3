Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab3ENS7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:59:23 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59264 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152Ab3ENS7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:59:21 -0400
MIME-Version: 1.0
In-Reply-To: <1368550322-1045-11-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
	<1368550322-1045-11-git-send-email-jiang.liu@huawei.com>
Date: Tue, 14 May 2013 11:59:20 -0700
X-Google-Sender-Auth: 4lMK5sxjcAZKNpnAs572yhlKi4o
Message-ID: <CAE9FiQWmZ8k88LJeXHVs+G+HPK_PbFE4ADoB=uKv_fVV34vLWg@mail.gmail.com>
Subject: Re: [RFC PATCH v2, part 2 11/18] PCI, x86: use hotplug-safe iterators
 to walk PCI buses
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
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 9:51 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Enhance x86 architecture specific code to use hotplug-safe iterators
> to walk PCI buses.
>
> In other words, replace pci_find_bus(), pci_find_next_bus() and
> pci_root_buses with pci_bus_exists(), pci_get_bus(), pci_get_next_bus()
> and pci_get_next_root_bus() etc.
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Myron Stowe <myron.stowe@redhat.com>
> Cc: Yijing Wang <wangyijing@huawei.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/x86/pci/acpi.c   | 3 ++-
>  arch/x86/pci/common.c | 3 ++-
>  arch/x86/pci/i386.c   | 9 ++++-----
>  arch/x86/pci/irq.c    | 2 +-
>  arch/x86/pci/legacy.c | 2 +-
>  5 files changed, 10 insertions(+), 9 deletions(-)

Acked-by: Yinghai Lu <yinghai@kernel.org>
