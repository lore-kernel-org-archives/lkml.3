Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762390AbaGRXDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:03:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbaGRXDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:03:19 -0400
Date: Fri, 18 Jul 2014 16:03:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Benoit Taine <benoit.taine@lip6.fr>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] ipack: Replace DEFINE_PCI_DEVICE_TABLE macro use
Message-ID: <20140718230318.GA8919@kroah.com>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
 <1405697232-11785-26-git-send-email-benoit.taine@lip6.fr>
 <1405699156.2237.4.camel@fourier>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405699156.2237.4.camel@fourier>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 05:59:16PM +0200, Samuel Iglesias Gonsálvez wrote:
> On Fri, 2014-07-18 at 17:27 +0200, Benoit Taine wrote:
> > We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
> > kernel coding style guidelines. This issue was reported by checkpatch.
> > 
> > Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
> > 
> > ---
> > Tested by compilation without errors.
> > 
> >  drivers/ipack/carriers/tpci200.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
> > index c276fde..de5e321 100644
> > --- a/drivers/ipack/carriers/tpci200.c
> > +++ b/drivers/ipack/carriers/tpci200.c
> > @@ -618,7 +618,7 @@ static void tpci200_pci_remove(struct pci_dev *dev)
> >  	__tpci200_pci_remove(tpci200);
> >  }
> >  
> > -static DEFINE_PCI_DEVICE_TABLE(tpci200_idtable) = {
> > +static const struct pci_device_id tpci200_idtable[] = {
> >  	{ TPCI200_VENDOR_ID, TPCI200_DEVICE_ID, TPCI200_SUBVENDOR_ID,
> >  	  TPCI200_SUBDEVICE_ID },
> >  	{ 0, },
> > 
> > 
> 
> Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> 
> Greg, Would you mind picking this patch through your char-misc tree?

Will do, thanks.

greg k-h
