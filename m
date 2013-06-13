Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab3FMLzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 07:55:39 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35983 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab3FMLzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 07:55:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Roman Yepishev <roman.yepishev@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
Date: Thu, 13 Jun 2013 14:04:46 +0200
Message-ID: <5579473.Q0gAQnMCR1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQWDDqcUwNDfOgBKOLrm7K811P=foK3-ZavFEkdUj=bSDg@mail.gmail.com>
References: <CAErSpo6v0mj9=Q13d=G4hho0mb9XTcsmefzke9fROYmZ7oBWxQ@mail.gmail.com> <CAErSpo7gL3Ds9oq8ZZ4zdt1uHy9xbkWJE+Ja=-0QXFQECjr40A@mail.gmail.com> <CAE9FiQWDDqcUwNDfOgBKOLrm7K811P=foK3-ZavFEkdUj=bSDg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 12, 2013 10:47:08 PM Yinghai Lu wrote:
> On Wed, Jun 12, 2013 at 8:50 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Wed, Jun 12, 2013 at 1:41 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >
> > I think you're saying that in systems that support both acpiphp and
> > pciehp, we should be using pciehp, but we currently use acpiphp.  If
> > so, that's certainly a bug.  How serious is it?  Is it a disaster if
> > we use acpiphp until we can resolve this cleanly?  Are there a lot of
> > systems that claim to support acpiphp but it doesn't actually work?
> 
> No sure. To make acpiphp would need more expertise in bios.
> Normally BIOS vendor would have half done work there, and will need
> OEM or system vendor have someone to make it work ....
> You would not want to read asl code in DSDT to help them out.
> That is not something that we can control.

However, pciehp may simply not work by itself on those systems.

It's pretty much like saying "Oh, _CRS may be screwed up, so let's just ignore
it", which isn't overly smart.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
