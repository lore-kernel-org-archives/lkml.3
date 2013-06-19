Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3FSOrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:47:41 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:5440 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab3FSOrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:47:39 -0400
Message-ID: <1371653237.22206.12.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Remove the use of
 CONFIG_ACPI_HOTPLUG_MEMORY_MODULE
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: rjw@sisk.pl, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 19 Jun 2013 08:47:17 -0600
In-Reply-To: <51C13703.8040909@jp.fujitsu.com>
References: <1371589605-15638-1-git-send-email-toshi.kani@hp.com>
	 <51C13703.8040909@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 13:43 +0900, Yasuaki Ishimatsu wrote:
> 2013/06/19 6:06, Toshi Kani wrote:
> > config ACPI_HOTPLUG_MEMORY has been changed to bool (y/n), and
> > its module option is no longer valid.  So, remove the use of
> > CONFIG_ACPI_HOTPLUG_MEMORY_MODULE.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> >   include/linux/acpi.h |    3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> > index 17b5b59..353ba25 100644
> > --- a/include/linux/acpi.h
> > +++ b/include/linux/acpi.h
> > @@ -352,8 +352,7 @@ extern acpi_status acpi_pci_osc_control_set(acpi_handle handle,
> >   
> >   /* Enable _OST when all relevant hotplug operations are enabled */
> >   #if defined(CONFIG_ACPI_HOTPLUG_CPU) &&			\
> > -	(defined(CONFIG_ACPI_HOTPLUG_MEMORY) ||		\
> > -	 defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)) &&	\
> > +	defined(CONFIG_ACPI_HOTPLUG_MEMORY) &&		\
> >   	defined(CONFIG_ACPI_CONTAINER)
> >   #define ACPI_HOTPLUG_OST
> >   #endif
> > --
> Good catch!!
> 
> Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks Yasuaki!
-Toshi


