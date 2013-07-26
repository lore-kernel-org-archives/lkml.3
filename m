Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab3GZMRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:17:50 -0400
Received: from mxout1.idt.com ([157.165.5.25]:52359 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366Ab3GZMRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:17:49 -0400
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Jean Delvare <jdelvare@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@Prodrive.nl>,
        Micha Nelissen <micha.nelissen@Prodrive.nl>,
        Stef van Os <stef.van.os@Prodrive.nl>
Subject: RE: [PATCH 5/7] rapidio: add modular build option for the subsystem
 core
Thread-Topic: [PATCH 5/7] rapidio: add modular build option for the
 subsystem core
Thread-Index: AQHOdDR6XdLKqX3OMUOPT0agD/FjEZl3a7sA//+bFfA=
Date: Fri, 26 Jul 2013 12:17:25 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D14BC3D462@corpmail1.na.ads.idt.com>
References: <1372447136-5751-1-git-send-email-alexandre.bounine@idt.com>
	 <1372447136-5751-6-git-send-email-alexandre.bounine@idt.com>
 <1374836454.4361.2.camel@chaos.site>
In-Reply-To: <1374836454.4361.2.camel@chaos.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.29]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6QCHtkH011013

Hi Jean,

> -----Original Message-----
> From: Jean Delvare [mailto:jdelvare@suse.de]
> Sent: Friday, July 26, 2013 7:01 AM

... skip ....

> @@ -2246,11 +2246,11 @@ source "drivers/pcmcia/Kconfig"
> >  source "drivers/pci/hotplug/Kconfig"
> >
> >  config RAPIDIO
> > -	bool "RapidIO support"
> > +	tristate "RapidIO support"
> 
> Is there a reason why this was only done for x86 and not for mips and
> powerpc?
> 

I need to make a configuration patch for MIPS and PowerPC platforms that deals
with built-in RapidIO controllers available in some embedded SoCs.
For generic platforms with PCIe controllers 'tristate' changes similar to x86 are good enough.
I think it was mentioned in PATCH 0/7 that we will have a follow-up patch a bit later.      

> >  	depends on PCI
> >  	default n
> >  	help
> > -	  If you say Y here, the kernel will include drivers and
> > +	  If enabled this option will include drivers and the core
> >  	  infrastructure code to support RapidIO interconnect devices.
> >
> 
> --
> Jean Delvare
> Suse L3

Alex.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
