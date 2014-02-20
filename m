Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaBTKtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:49:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48557 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbaBTKtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:49:43 -0500
Date: Thu, 20 Feb 2014 11:49:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aristeu Rozanski <aris@redhat.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb_edac: degrade log level for "EDAC sbridge: Seeking
 for: dev 1d.3 PCI ID xxxx"
Message-ID: <20140220104940.GC8876@pd.tnic>
References: <1392613824-11230-1-git-send-email-jiang.liu@linux.intel.com>
 <20140217143236.GS15457@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140217143236.GS15457@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 09:32:36AM -0500, Aristeu Rozanski wrote:
> On Mon, Feb 17, 2014 at 01:10:23PM +0800, Jiang Liu wrote:
> > On a system with four Intel processor, it generates too many messages
> > "EDAC sbridge: Seeking for: dev 1d.3 PCI ID xxxx". And it doesn't
> > give many useful information for normal users, so change log level
> > from INFO to DEBUG.
> > 
> > Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> > ---
> >  drivers/edac/sb_edac.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
> > index 54e2abe..347c7a1 100644
> > --- a/drivers/edac/sb_edac.c
> > +++ b/drivers/edac/sb_edac.c
> > @@ -1263,7 +1263,7 @@ static int sbridge_get_onedevice(struct pci_dev **prev,
> >  	struct pci_dev *pdev = NULL;
> >  	u8 bus = 0;
> >  
> > -	sbridge_printk(KERN_INFO,
> > +	sbridge_printk(KERN_DEBUG,
> >  		"Seeking for: dev %02x.%d PCI ID %04x:%04x\n",
> >  		dev_descr->dev, dev_descr->func,
> >  		PCI_VENDOR_ID_INTEL, dev_descr->dev_id);
> 
> ACK

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
