Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764605Ab3DDUK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:10:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51420 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764182Ab3DDUK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:10:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 0/4] PCI/PM: D3cold support for system suspend
Date: Thu, 04 Apr 2013 22:18:04 +0200
Message-ID: <40154903.vXKcu58qDG@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo6m=3txSUH5Bwm7Y7K=25UWA4-kgPs_fs-Pa8jkP5WRDA@mail.gmail.com>
References: <1359434058-15918-1-git-send-email-ying.huang@intel.com> <CAErSpo6m=3txSUH5Bwm7Y7K=25UWA4-kgPs_fs-Pa8jkP5WRDA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 04, 2013 12:26:52 PM Bjorn Helgaas wrote:
> On Mon, Jan 28, 2013 at 9:34 PM, Huang Ying <ying.huang@intel.com> wrote:
> > [PATCH 1/4] PCI/ACPI: Add target state as parameter to pci_platform_pm_ops->run_wake
> > [PATCH 2/4] PCI: Rename pci_dev->runtime_d3cold to pci_dev->set_d3cold
> > [PATCH 3/4] PCI/PM: Set pci_dev->set_d3cold in pci_set_power_state
> > [PATCH 4/4] PCI/PM: Enable D3cold support for system suspend
> 
> Do we still need these?
> 
> What problem do they solve?  Or what new functionality do they add?

They were supposed to allow PCI devices to be put into D3cold (via ACPI)
during system suspend, but I think it's better not to do that at this
point.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
