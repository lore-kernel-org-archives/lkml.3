Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaG2PK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:10:57 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42861 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbaG2PKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:10:49 -0400
Date: Tue, 29 Jul 2014 16:10:42 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Michael Welling <mwelling@emacinc.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, rogerq@ti.com, stern@rowland.harvard.edu,
        balbi@ti.com, stable@vger.kernel.org
Subject: Re: [PATCH] mfd: omap-usb-host: Fix improper mask use
Message-ID: <20140729151042.GB9030@lee--X1>
References: <1406588464-19104-1-git-send-email-mwelling@emacinc.com>
 <20140729083325.GA9030@lee--X1>
 <20140729145734.GA8307@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140729145734.GA8307@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Greg KH wrote:

> On Tue, Jul 29, 2014 at 09:33:25AM +0100, Lee Jones wrote:
> > single-ulpi-bypass is a flag used for older OMAP3 silicon.
> > 
> > The flag when set, can excite code that improperly uses the
> > OMAP_UHH_HOSTCONFIG_UPLI_BYPASS define to clear the corresponding bit.
> > Instead it clears all of the other bits disabling all of the ports in
> > the process.
> > 
> > Signed-off-by: Michael Welling <mwelling@emacinc.com>
> > ---
> > 
> > --> Applied, thanks. <--
> > 
> >  drivers/mfd/omap-usb-host.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> </formletter>

It was worth a try. ;)

Patch queued for MFD -next and 'Cc: stable@vger.kernel.org' tag added.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
