Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaBQOcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:32:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaBQOcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:32:42 -0500
Date: Mon, 17 Feb 2014 09:32:36 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb_edac: degrade log level for "EDAC sbridge: Seeking
 for: dev 1d.3 PCI ID xxxx"
Message-ID: <20140217143236.GS15457@redhat.com>
References: <1392613824-11230-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392613824-11230-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 01:10:23PM +0800, Jiang Liu wrote:
> On a system with four Intel processor, it generates too many messages
> "EDAC sbridge: Seeking for: dev 1d.3 PCI ID xxxx". And it doesn't
> give many useful information for normal users, so change log level
> from INFO to DEBUG.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/edac/sb_edac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
> index 54e2abe..347c7a1 100644
> --- a/drivers/edac/sb_edac.c
> +++ b/drivers/edac/sb_edac.c
> @@ -1263,7 +1263,7 @@ static int sbridge_get_onedevice(struct pci_dev **prev,
>  	struct pci_dev *pdev = NULL;
>  	u8 bus = 0;
>  
> -	sbridge_printk(KERN_INFO,
> +	sbridge_printk(KERN_DEBUG,
>  		"Seeking for: dev %02x.%d PCI ID %04x:%04x\n",
>  		dev_descr->dev, dev_descr->func,
>  		PCI_VENDOR_ID_INTEL, dev_descr->dev_id);

ACK

-- 
Aristeu

