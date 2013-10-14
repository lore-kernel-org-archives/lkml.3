Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab3JNWTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 18:19:04 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:17298 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab3JNWTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 18:19:01 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "chirag.kantharia@hp.com" <chirag.kantharia@hp.com>
CC: ISS StorageDev <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] cpqarray: remove deprecated IRQF_DISABLED
Thread-Topic: [PATCH] cpqarray: remove deprecated IRQF_DISABLED
Thread-Index: AQHOxwG2xLVK6KGd70yErpsCLd2ZjZn0x1qQ
Date: Mon, 14 Oct 2013 22:17:27 +0000
Message-ID: <48275AD710FCA34184C2B6186B4016B32D14B4D5@G6W2491.americas.hpqcorp.net>
References: <1381551329-6098-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1381551329-6098-1-git-send-email-michael.opdenacker@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.193.49.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Michael Opdenacker [mailto:michael.opdenacker@free-
> electrons.com]
> Sent: Friday, October 11, 2013 11:15 PM
> To: chirag.kantharia@hp.com
> Cc: ISS StorageDev; linux-kernel@vger.kernel.org; Michael Opdenacker
> Subject: [PATCH] cpqarray: remove deprecated IRQF_DISABLED
> 
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.

I plan to send a patch soon to remove cpqarray completely.

-- mikem

> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-
> electrons.com>
> ---
>  drivers/block/cpqarray.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c index
> 2b94403..370721e 100644
> --- a/drivers/block/cpqarray.c
> +++ b/drivers/block/cpqarray.c
> @@ -406,7 +406,7 @@ static int cpqarray_register_ctlr(int i, struct pci_dev
> *pdev)
>  	}
>  	hba[i]->access.set_intr_mask(hba[i], 0);
>  	if (request_irq(hba[i]->intr, do_ida_intr,
> -		IRQF_DISABLED|IRQF_SHARED, hba[i]->devname, hba[i]))
> +		IRQF_SHARED, hba[i]->devname, hba[i]))
>  	{
>  		printk(KERN_ERR "cpqarray: Unable to get irq %d for %s\n",
>  				hba[i]->intr, hba[i]->devname);
> --
> 1.8.1.2

