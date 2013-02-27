Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab3B0PSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:18:12 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49153 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab3B0PSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:18:10 -0500
Date: Wed, 27 Feb 2013 09:17:52 -0600
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        josh.h.morris@us.ibm.com
Subject: Re: [PATCH 3/4] block: IBM RamSan 70/80 branding changes.
Message-ID: <20130227151752.GB10908@oc6784271780.ibm.com>
References: <20130225185815.GA7974@oc6784271780.ibm.com>
 <1361822854.2724.1.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361822854.2724.1.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022715-7182-0000-0000-0000058D7A55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your response. Comment inline.

I send a new patch soon.

On Mon, Feb 25, 2013 at 12:07:34PM -0800, Joe Perches wrote:
> On Mon, 2013-02-25 at 12:58 -0600, Philip J. Kelleher wrote:
> > From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> > 
> > This patch includes changing the hardware branding name from
> > IBM RamSan to IBM FlashSystem.
> 
> just a trivial comment
> 
> > diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
> []
> > @@ -45,16 +45,14 @@
> >  
> >  struct proc_cmd;
> >  
> > -#define PCI_VENDOR_ID_TMS_IBM		0x15B6
> > -#define PCI_DEVICE_ID_RS70_FLASH	0x0019
> > -#define PCI_DEVICE_ID_RS70D_FLASH	0x001A
> > -#define PCI_DEVICE_ID_RS80_FLASH	0x001C
> > -#define PCI_DEVICE_ID_RS81_FLASH	0x001E
> > +#define PCI_VENDOR_ID_IBM		0x1014
> 
> PCI_VENDOR_ID_IBM is already #defined in pci_ids.h
> 
> 

Alright.... good to know. Thanks.

