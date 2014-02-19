Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaBSIaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:30:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:16843 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaBSIaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:30:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="477535774"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Joerg Roedel <joro@8bytes.org>, "Dutt, Sudeep" <sudeep.dutt@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: RE: [PATCH v2 2/4] mei: Add include of <linux/irqreturn.h>
Thread-Topic: [PATCH v2 2/4] mei: Add include of <linux/irqreturn.h>
Thread-Index: AQHPLOxh5VvaxIa+hU6/RociTKEPfJq8Pxfw
Date: Wed, 19 Feb 2014 08:29:52 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF74107@HASMSX106.ger.corp.intel.com>
References: <20140218205925.11014.14973.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140218205946.11014.13654.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140218205946.11014.13654.stgit@bhelgaas-glaptop.roam.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1J8USfG003912



> 
> We currently include <linux/irqreturn.h> in <linux/pci.h>, but I'm about to
> remove that from linux/pci.h, so add explicit includes where needed.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/misc/mei/hw-me.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
> index 80bd829fbd9a..893d5119fa9b 100644
> --- a/drivers/misc/mei/hw-me.h
> +++ b/drivers/misc/mei/hw-me.h
> @@ -20,6 +20,7 @@
>  #define _MEI_INTERFACE_H_
> 
>  #include <linux/mei.h>
> +#include <linux/irqreturn.h>
>  #include "mei_dev.h"
>  #include "client.h"


Okay.
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
