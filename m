Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514Ab3BKXVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:21:14 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:46261 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427Ab3BKXVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:21:13 -0500
Message-ID: <1360624234.3869.61.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Remove the use of CONFIG_ACPI_CONTAINER_MODULE
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Feb 2013 16:10:34 -0700
In-Reply-To: <2134502.Uo3joRHVj1@vostro.rjw.lan>
References: <1360622000-22140-1-git-send-email-toshi.kani@hp.com>
	 <2134502.Uo3joRHVj1@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 00:22 +0100, Rafael J. Wysocki wrote:
> On Monday, February 11, 2013 03:33:20 PM Toshi Kani wrote:
> > config ACPI_CONTAINER has been changed to bool (y/n), and its
> > module option is no longer valid.  So, remove the use of
> > CONFIG_ACPI_CONTAINER_MODULE.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> 
> I'm going to take it.

Thanks!
-Toshi


> 
> Thanks,
> Rafael
> 
> 
> > ---
> >  include/linux/acpi.h |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> > index c6ccd9f..bcbdd74 100644
> > --- a/include/linux/acpi.h
> > +++ b/include/linux/acpi.h
> > @@ -363,8 +363,7 @@ extern acpi_status acpi_pci_osc_control_set(acpi_handle handle,
> >  #if defined(CONFIG_ACPI_HOTPLUG_CPU) &&			\
> >  	(defined(CONFIG_ACPI_HOTPLUG_MEMORY) ||		\
> >  	 defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)) &&	\
> > -	(defined(CONFIG_ACPI_CONTAINER) ||		\
> > -	 defined(CONFIG_ACPI_CONTAINER_MODULE))
> > +	defined(CONFIG_ACPI_CONTAINER)
> >  #define ACPI_HOTPLUG_OST
> >  #endif
> >  
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


