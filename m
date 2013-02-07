Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab3BGOsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:48:30 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:32526 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3BGOs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:48:28 -0500
Message-ID: <1360247896.14416.11.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/2] ACPI / scan: Simplify container driver
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 07 Feb 2013 07:38:16 -0700
In-Reply-To: <7621884.ddmYGtd8MJ@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan>
	 <5090866.2BHgpRnuEZ@vostro.rjw.lan> <5113668F.9060102@jp.fujitsu.com>
	 <7621884.ddmYGtd8MJ@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 12:43 +0100, Rafael J. Wysocki wrote:
> On Thursday, February 07, 2013 05:32:15 PM Yasuaki Ishimatsu wrote:
 :
> > > Index: test/drivers/acpi/internal.h
> > > ===================================================================
> > > --- test.orig/drivers/acpi/internal.h
> > > +++ test/drivers/acpi/internal.h
> > > @@ -40,6 +40,11 @@ void acpi_memory_hotplug_init(void);
> > >   #else
> > >   static inline void acpi_memory_hotplug_init(void) {}
> > >   #endif
> > 
> > > +#ifdef ACPI_CONTAINER
> > 
> > It should be CONFIG_ACPI_CONTAINER.
> 
> Totally correct.

Just FYI, this change is included in my patch 2/2 as well.
https://patchwork.kernel.org/patch/2108881/

Thanks,
-Toshi


> > By this, acpi_container_init() do nothing. When I fix it and test the patch,
> > the patch goes well.
> > 
> > If you update the patch, I'll test again.
> 
> This fix from Toshi Kani is necessary in addition to it, though
> 
> https://patchwork.kernel.org/patch/2108851/
> 
> because FORCE_EJECT is never set as far as I can say.
> 
> Thanks,
> Rafael
> 
> 
> 


