Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963AbaKCX3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:29:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaKCX3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:29:14 -0500
Date: Mon, 3 Nov 2014 15:29:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Oussama Ghorbel <ghorbel@pivasoftware.com>, Rabin Vincent <rabin@rab.in>,
        rogerq@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] phy: omap-usb2: Enable runtime PM of omap-usb2 phy
 properly
Message-ID: <20141103232913.GA7454@kroah.com>
References: <20141006194418.GA399@debian>
 <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com>
 <54576545.8030300@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54576545.8030300@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:51:41PM +0530, Kishon Vijay Abraham I wrote:
> Hi Greg,
> 
> On Tuesday 07 October 2014 04:32 PM, Oussama Ghorbel wrote:
> > The USB OTG port does not work since v3.16 on omap platform.
> > This is a regression introduced by the commit
> > eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
> >  and remove).
> > This because the call to pm_runtime_enable() function is moved after the
> > call to devm_phy_create() function, which has side effect since later in
> > the subsequent calls of devm_phy_create() there is a check with
> > pm_runtime_enabled() to configure few things.
> 
> This is the only fix for this -rc cycle in the PHY susbsystem. So can you take
> this directly? Or else I can prepare a pull request. Let me know.
> 
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>

I don't have this in my archives anymore, please resend so that I can
apply it from an email.

thanks,

greg k-h
