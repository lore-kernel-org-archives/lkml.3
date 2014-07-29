Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaG2O6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:58:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbaG2O6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:58:01 -0400
Date: Tue, 29 Jul 2014 07:57:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Michael Welling <mwelling@emacinc.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, rogerq@ti.com, stern@rowland.harvard.edu,
        balbi@ti.com, stable@vger.kernel.org
Subject: Re: [PATCH] mfd: omap-usb-host: Fix improper mask use
Message-ID: <20140729145734.GA8307@kroah.com>
References: <1406588464-19104-1-git-send-email-mwelling@emacinc.com>
 <20140729083325.GA9030@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729083325.GA9030@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 09:33:25AM +0100, Lee Jones wrote:
> single-ulpi-bypass is a flag used for older OMAP3 silicon.
> 
> The flag when set, can excite code that improperly uses the
> OMAP_UHH_HOSTCONFIG_UPLI_BYPASS define to clear the corresponding bit.
> Instead it clears all of the other bits disabling all of the ports in
> the process.
> 
> Signed-off-by: Michael Welling <mwelling@emacinc.com>
> ---
> 
> --> Applied, thanks. <--
> 
>  drivers/mfd/omap-usb-host.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
