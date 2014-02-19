Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbaBSRST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:18:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:39832 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbaBSRSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:18:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,506,1389772800"; 
   d="scan'208";a="477802634"
Subject: Re: [PATCH v2 1/4] misc: mic: Add include of <linux/irqreturn.h>
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        iommu@lists.linux-foundation.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Aaron F Brown <aaron.f.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>
In-Reply-To: <20140218205939.11014.41761.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140218205925.11014.14973.stgit@bhelgaas-glaptop.roam.corp.google.com>
	 <20140218205939.11014.41761.stgit@bhelgaas-glaptop.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Feb 2014 09:09:49 -0800
Message-ID: <1392829789.15950.13.camel@rbtaylor-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 13:59 -0700, Bjorn Helgaas wrote:
> We currently include <linux/irqreturn.h> in <linux/pci.h>, but I'm about to
> remove that from linux/pci.h, so add explicit includes where needed.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/misc/mic/card/mic_device.h |    1 +
>  drivers/misc/mic/host/mic_device.h |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/misc/mic/card/mic_device.h b/drivers/misc/mic/card/mic_device.h
> index 347b9b3b7916..306f502be95e 100644
> --- a/drivers/misc/mic/card/mic_device.h
> +++ b/drivers/misc/mic/card/mic_device.h
> @@ -29,6 +29,7 @@
>  
>  #include <linux/workqueue.h>
>  #include <linux/io.h>
> +#include <linux/irqreturn.h>
>  
>  /**
>   * struct mic_intr_info - Contains h/w specific interrupt sources info
> diff --git a/drivers/misc/mic/host/mic_device.h b/drivers/misc/mic/host/mic_device.h
> index 1a6edce2ecde..0398c696d257 100644
> --- a/drivers/misc/mic/host/mic_device.h
> +++ b/drivers/misc/mic/host/mic_device.h
> @@ -24,6 +24,7 @@
>  #include <linux/cdev.h>
>  #include <linux/idr.h>
>  #include <linux/notifier.h>
> +#include <linux/irqreturn.h>
>  
>  #include "mic_intr.h"
>  
> 

Acked-by: Sudeep Dutt <sudeep.dutt@intel.com>

Thanks,



