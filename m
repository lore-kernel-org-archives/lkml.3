Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3FZWfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:35:05 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52510 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab3FZWfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:35:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
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
Subject: Re: [PATCH 6/6] x86/PCI: quirk Thunderbolt PCI-to-PCI bridges
Date: Thu, 27 Jun 2013 00:44:30 +0200
Message-ID: <1606295.H1unv8GDgk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQVCQKjPa1dVKhAubvD+d=rudOxLaRMYAr-GAC7eSSz09Q@mail.gmail.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com> <CAE9FiQW9xuu6WjH59td6Jve10kokoxU4mNqj4DRyg7beqBzHDA@mail.gmail.com> <CAE9FiQVCQKjPa1dVKhAubvD+d=rudOxLaRMYAr-GAC7eSSz09Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 26, 2013 03:31:18 PM Yinghai Lu wrote:
> On Wed, Jun 26, 2013 at 3:26 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Wed, Jun 26, 2013 at 3:18 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> On Tue, Jun 25, 2013 at 10:22 AM, Mika Westerberg
> >> <mika.westerberg@linux.intel.com> wrote:
> >>> Thunderbolt PCI-to-PCI bridges typically use BIOS "assisted" enumeration.
> >>> This means that the BIOS will allocate bridge resources based on some
> >>> assumptions of a maximum Thunderbolt chain. It also disables native PCIe
> >>> hotplug of the root port where the Thunderbolt host router is connected.
> >
> > We should not need tricks in this patch after
> >
> > https://patchwork.kernel.org/patch/2766521/
> >
> > [2/3] PCI / ACPI: Use boot-time resource allocation rules during hotplug
> >
> 
> BTW, Rafael, looks like that "boot-time" is not accurate here.
> 
> During acpi hotplug, firmare could do extra help for us like assign
> some resources to pci device bars, so it is NOT "boot-time".

Well, Linus has merged it already and besides "boot-time rules" need not
mean "boot-time resources", right?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
