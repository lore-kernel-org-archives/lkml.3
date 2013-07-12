Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965460Ab3GLUyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:54:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40342 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965378Ab3GLUyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:54:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC][PATCH 0/30] ACPI / hotplug / PCI: Major rework + Thunderbolt workarounds
Date: Fri, 12 Jul 2013 23:04:26 +0200
Message-ID: <5687298.pUqv2oM5bn@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130712131850.GL4898@intel.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan> <20130712131850.GL4898@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 12, 2013 04:18:50 PM Mika Westerberg wrote:
> On Fri, Jul 12, 2013 at 01:34:20AM +0200, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > I've made some progress with my ACPIPHP rework since I posted the series last
> > time and here goes an update.
> > 
> > First off, the previous series was somewhat racy, which should be fixed now.
> > Apart from this there's quite some new material on top of the patches I posted
> > last time (or rather on top of their new versions) and I integrated the
> > Thunderbolt series from Mika with that.  As a result,
> > 
> > https://patchwork.kernel.org/patch/2817341/
> > 
> > is required to be applied.
> 
> With the above mentioned patch applied + fix for patch [23/30], I tested
> this series on Acer Aspire S5 and Intel DZ77RE-75K desktop and Thunderbolt
> works just fine :-)
> 
> You can add
> 
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> to the series.

Thanks a lot, that's really helpful!

Now I can rebase it on the previous cleanups and we'll see how that all
together works on top of the Linus' current. :-)

> Nice cleanup!

Thanks!

