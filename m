Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab3AUVW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:22:27 -0500
Received: from mout.gmx.net ([212.227.15.18]:49637 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab3AUVWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:22:23 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+fyrcCkDyfapw/VSjfvtOCHfJofMIHbOaLouI5JQ
	o416wa2FGXxe7G
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH 1/2] staging/comedi: Add pci_driver.name to skel driver
Date: Mon, 21 Jan 2013 22:25:29 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.4; KDE/4.9.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1358801517-18265-1-git-send-email-peterhuewe@gmx.de> <ADE657CA350FB648AAC2C43247A983F00207A6F69495@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00207A6F69495@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301212225.29314.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 21. Januar 2013, 21:56:22 schrieb H Hartley Sweeten:
> On Monday, January 21, 2013 1:52 PM, Peter Huewe wrote:
> > This patch adds the comedi_driver.name to pci_driver.name
> > to the skel driver, so we can remove the workaround in drivers.c
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > ---
> > 
> >  drivers/staging/comedi/drivers/skel.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/staging/comedi/drivers/skel.c
> > b/drivers/staging/comedi/drivers/skel.c index e2d7970..4a40498 100644
> > --- a/drivers/staging/comedi/drivers/skel.c
> > +++ b/drivers/staging/comedi/drivers/skel.c
> > @@ -713,6 +713,7 @@ static void skel_pci_remove(struct pci_dev *dev)
> > 
> >  }
> >  
> >  static struct pci_driver skel_pci_driver = {
> > 
> > +	.name = "dummy"
> > 
> >  	.id_table = skel_pci_table,
> >  	.probe = &skel_pci_probe,
> >  	.remove = &skel_pci_remove
> 
> Hmm... I was just about to post a rebase of the last part of my drivers.c
> cleanup that included this and your 2/2 patch.
> 
> Oh well... Rebase again...
> 
> FWIW, for both patches.
> 
> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

It's okay to drop my patches so you don't have to rebase.

(I posted a version with the missing comma nevertheless)


Thanks,
Peter
