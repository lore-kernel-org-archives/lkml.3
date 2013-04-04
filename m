Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764498Ab3DDS1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:27:16 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:38083 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764461Ab3DDS1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:27:13 -0400
MIME-Version: 1.0
In-Reply-To: <1359434058-15918-1-git-send-email-ying.huang@intel.com>
References: <1359434058-15918-1-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 4 Apr 2013 12:26:52 -0600
Message-ID: <CAErSpo6m=3txSUH5Bwm7Y7K=25UWA4-kgPs_fs-Pa8jkP5WRDA@mail.gmail.com>
Subject: Re: [PATCH 0/4] PCI/PM: D3cold support for system suspend
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 9:34 PM, Huang Ying <ying.huang@intel.com> wrote:
> [PATCH 1/4] PCI/ACPI: Add target state as parameter to pci_platform_pm_ops->run_wake
> [PATCH 2/4] PCI: Rename pci_dev->runtime_d3cold to pci_dev->set_d3cold
> [PATCH 3/4] PCI/PM: Set pci_dev->set_d3cold in pci_set_power_state
> [PATCH 4/4] PCI/PM: Enable D3cold support for system suspend

Do we still need these?

What problem do they solve?  Or what new functionality do they add?
