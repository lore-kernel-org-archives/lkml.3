Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3BCUMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 15:12:43 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:58769 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab3BCUMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 15:12:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 4/8] ACPI, PCI: avoid building pci_slot as module
Date: Sun, 03 Feb 2013 21:18:55 +0100
Message-ID: <10475811.H5RONrFZPm@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo4fbNzFaBxH+eKD+BKVgghyCJEYLDMzc6_gdxABAPe3QQ@mail.gmail.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <3500982.MUDp6kKU3R@vostro.rjw.lan> <CAErSpo4fbNzFaBxH+eKD+BKVgghyCJEYLDMzc6_gdxABAPe3QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 28, 2013 02:09:22 PM Bjorn Helgaas wrote:
> On Sun, Jan 20, 2013 at 5:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, January 19, 2013 12:07:42 AM Jiang Liu wrote:
> >> As discussed in thread at https://patchwork.kernel.org/patch/1946851/,
> >> there's no value in supporting CONFIG_ACPI_PCI_SLOT=m any more.
> >> So change Kconfig and code to only support building pci_slot as
> >> built-in driver.
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> >
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> I think we should eventually get rid of acpi_pci_register_driver() and
> do this initialization directly from acpi_pci_root_add().  But
> removing the module option here is a good first step.
> 
> Rafael, do you want to apply this (and [6/8]) via your tree?  If not,
> I can take it.

Both applied to bleeding-edge.  I've added your ACK to the [6/8] too, hope
that's OK.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
