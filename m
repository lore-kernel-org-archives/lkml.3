Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935033AbaKNDOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:14:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:51009 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933486AbaKNDOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:14:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,382,1413270000"; 
   d="scan'208";a="622169923"
Message-ID: <546573A3.60303@linux.intel.com>
Date: Fri, 14 Nov 2014 11:14:43 +0800
From: "Lu, Baolu" <baolu.lu@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] Rework "xhci: clear root port wake on bits if
 controller isn't wake-up capable"
References: <1415242253-72501-1-git-send-email-baolu.lu@linux.intel.com>
In-Reply-To: <1415242253-72501-1-git-send-email-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathias,

This patch series has been acked by Alan Stern. There seems no further 
comments from others. Can you please pull in it?

Thanks,
-baolu

On 2014年11月06日 10:50, Lu Baolu wrote:
> This serie of patch reworks commit ff8cbf250b448aac35589f6075082c3fcad8a8fe.
> This has been discussed at http://www.spinics.net/lists/linux-usb/msg114986.html
> It also includes a patch to fix a comment in drivers/usb/host/xhci.h.
>
> Changes in v4:
> 	- Refine xhci_disable_port_wake_on_bits().
> 	- Add "Acked-by: Alan Stern"
>
> Changes in v3:
> 	- Need to consider run-time suspend as well.
> 	- Change "wake-up capable" to "allowed to do wakeup"
> 	    in both comments and patch description.
> 	- Add "Suggested-by: Alan Stern"
>
> Changes in v2:
> 	- Should not be a quirk.
> 	- Should be applied to all xhci controllers.
>
> Lu Baolu (3):
>    usb: xhci: Revert "xhci: clear root port wake on bits if controller
>      isn't wake-up capable"
>    usb: xhci: This reworks ff8cbf250b448aac35589f6075082c3fcad8a8fe
>    usb: xhci: fix comment for PORT_DEV_REMOVE
>
>   drivers/usb/host/xhci-hub.c  |  5 +----
>   drivers/usb/host/xhci-pci.c  |  2 +-
>   drivers/usb/host/xhci-plat.c | 10 +++++++++-
>   drivers/usb/host/xhci.c      | 42 +++++++++++++++++++++++++++++++++++++++++-
>   drivers/usb/host/xhci.h      |  4 ++--
>   5 files changed, 54 insertions(+), 9 deletions(-)
>

