Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935357Ab3FSXKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:10:01 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43415 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934170Ab3FSXJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:09:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Remove the use of CONFIG_ACPI_HOTPLUG_MEMORY_MODULE
Date: Thu, 20 Jun 2013 01:19:21 +0200
Message-ID: <5242333.nvhyS5L0VS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371653237.22206.12.camel@misato.fc.hp.com>
References: <1371589605-15638-1-git-send-email-toshi.kani@hp.com> <51C13703.8040909@jp.fujitsu.com> <1371653237.22206.12.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 19, 2013 08:47:17 AM Toshi Kani wrote:
> On Wed, 2013-06-19 at 13:43 +0900, Yasuaki Ishimatsu wrote:
> > 2013/06/19 6:06, Toshi Kani wrote:
> > > config ACPI_HOTPLUG_MEMORY has been changed to bool (y/n), and
> > > its module option is no longer valid.  So, remove the use of
> > > CONFIG_ACPI_HOTPLUG_MEMORY_MODULE.
> > > 
> > > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > > ---
> > >   include/linux/acpi.h |    3 +--
> > >   1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> > > index 17b5b59..353ba25 100644
> > > --- a/include/linux/acpi.h
> > > +++ b/include/linux/acpi.h
> > > @@ -352,8 +352,7 @@ extern acpi_status acpi_pci_osc_control_set(acpi_handle handle,
> > >   
> > >   /* Enable _OST when all relevant hotplug operations are enabled */
> > >   #if defined(CONFIG_ACPI_HOTPLUG_CPU) &&			\
> > > -	(defined(CONFIG_ACPI_HOTPLUG_MEMORY) ||		\
> > > -	 defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)) &&	\
> > > +	defined(CONFIG_ACPI_HOTPLUG_MEMORY) &&		\
> > >   	defined(CONFIG_ACPI_CONTAINER)
> > >   #define ACPI_HOTPLUG_OST
> > >   #endif
> > > --
> > Good catch!!
> > 
> > Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> Thanks Yasuaki!

Queued up for 3.11.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
