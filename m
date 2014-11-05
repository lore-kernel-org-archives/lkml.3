Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaKEWaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:30:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaKEWaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:30:00 -0500
Date: Wed, 5 Nov 2014 14:29:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: omap-usb2: Enable runtime PM of omap-usb2 phy
 properly
Message-ID: <20141105222959.GA18892@kroah.com>
References: <1415081826-9297-1-git-send-email-kishon@ti.com>
 <20141105175422.GB2327@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105175422.GB2327@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 06:54:23PM +0100, Sebastian Reichel wrote:
> Hi,
> 
> On Tue, Nov 04, 2014 at 11:47:06AM +0530, Kishon Vijay Abraham I wrote:
> > From: Oussama Ghorbel <ghorbel@pivasoftware.com>
> > 
> > The USB OTG port does not work since v3.16 on omap platform.
> > This is a regression introduced by the commit
> > eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
> >  and remove).
> > This because the call to pm_runtime_enable() function is moved after the
> > call to devm_phy_create() function, which has side effect since later in
> > the subsequent calls of devm_phy_create() there is a check with
> > pm_runtime_enabled() to configure few things.
> > 
> > Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>
> > Tested-by: Rabin Vincent <rabin@rab.in>
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> stable annotations are missing. See
> 
> Documentation/stable_kernel_rules.txt

I can take care of that, thanks.

greg k-h
