Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3FZW1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:27:01 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:37741 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3FZW1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:27:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo58bCG4=hwC73VY+nXPk9-dZUb5eWERZ_wTtAfrXtBVmg@mail.gmail.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
	<1372177330-28013-7-git-send-email-mika.westerberg@linux.intel.com>
	<CAErSpo58bCG4=hwC73VY+nXPk9-dZUb5eWERZ_wTtAfrXtBVmg@mail.gmail.com>
Date: Wed, 26 Jun 2013 15:26:59 -0700
X-Google-Sender-Auth: 0kz_Y7GpsBoNjD7U92Z6vNnQL9A
Message-ID: <CAE9FiQW9xuu6WjH59td6Jve10kokoxU4mNqj4DRyg7beqBzHDA@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86/PCI: quirk Thunderbolt PCI-to-PCI bridges
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 3:18 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Jun 25, 2013 at 10:22 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
>> Thunderbolt PCI-to-PCI bridges typically use BIOS "assisted" enumeration.
>> This means that the BIOS will allocate bridge resources based on some
>> assumptions of a maximum Thunderbolt chain. It also disables native PCIe
>> hotplug of the root port where the Thunderbolt host router is connected.

We should not need tricks in this patch after

https://patchwork.kernel.org/patch/2766521/

[2/3] PCI / ACPI: Use boot-time resource allocation rules during hotplug

Thanks

Yinghai
