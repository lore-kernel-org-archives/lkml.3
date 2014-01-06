Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaAFLtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:49:10 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:50631 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaAFLtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:49:08 -0500
Date: Mon, 6 Jan 2014 11:49:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Samuel Ortiz <sameo@linux.intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: sta2x11-mfd: use named constants for
 pci_power_t values
Message-ID: <20140106114902.GB30156@lee--X1>
References: <1388706031-22180-1-git-send-email-Julia.Lawall@lip6.fr>
 <1388706031-22180-2-git-send-email-Julia.Lawall@lip6.fr>
 <20140106110145.GM23772@lee--X1>
 <alpine.DEB.2.10.1401061215560.2079@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.10.1401061215560.2079@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > >
> > > The semantic patch that makes this change is as follows:
> > > (http://coccinelle.lip6.fr/)
> > >
> > > // <smpl>
> > > @@
> > > expression pdev;
> > > @@
> > >
> > > pci_set_power_state(pdev,
> > > - 0
> > > + PCI_D0
> > >  )
> > > // </smpl>
> >
> > I'm happy with the code and that you used Coccinelle to discover the
> > issue, but I feel a little more explanation would be helpful to
> > readers.
> >
> > Why is (pci_power_t __force) 0 better than 0?
> 
> I wasn't particularly attached to the cast, and I don't know if it is an
> issue.  But in trying to understand the code, I found PCI_D0 more
> understandable than 0.

Well I don't want to waste any of your or my time, so I'll apply the
patch and add something along those lines to the commit message.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
