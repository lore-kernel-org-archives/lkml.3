Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab3FKWlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:41:22 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:34532 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3FKWlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:41:21 -0400
Message-ID: <1370990469.21540.5.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Remove unused flags in acpi_device_flags
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Jun 2013 16:41:09 -0600
In-Reply-To: <1929531.s4Kmz37sNk@vostro.rjw.lan>
References: <1370382985-12163-1-git-send-email-toshi.kani@hp.com>
	 <1929531.s4Kmz37sNk@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 00:24 +0200, Rafael J. Wysocki wrote:
> On Tuesday, June 04, 2013 03:56:25 PM Toshi Kani wrote:
> > suprise_removal_ok and performance_manageable in struct
> > acpi_device_flags are not used by any code.  So, remove
> > them.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> 
> Queued up for 3.11.

Great.  Thanks!
-Toshi

> 
> Thanks,
> Rafael
> 
> 
> > ---
> >  include/acpi/acpi_bus.h |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> > index 1a681ee..9efc52f 100644
> > --- a/include/acpi/acpi_bus.h
> > +++ b/include/acpi/acpi_bus.h
> > @@ -156,12 +156,10 @@ struct acpi_device_flags {
> >  	u32 dynamic_status:1;
> >  	u32 removable:1;
> >  	u32 ejectable:1;
> > -	u32 suprise_removal_ok:1;
> >  	u32 power_manageable:1;
> > -	u32 performance_manageable:1;
> >  	u32 eject_pending:1;
> >  	u32 match_driver:1;
> > -	u32 reserved:24;
> > +	u32 reserved:26;
> >  };
> >  
> >  /* File System */
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


