Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3CGB6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:58:13 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:58033 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab3CGB6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:58:11 -0500
Date: Thu, 7 Mar 2013 09:58:00 +0800
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/5] usb: musb: ux500: add otg notifier support
Message-ID: <20130307015800.GA2468@balto.lan>
References: <1362047934-22337-1-git-send-email-fabio.baltieri@linaro.org>
 <1362047934-22337-4-git-send-email-fabio.baltieri@linaro.org>
 <20130304143810.GJ3397@arwen.pp.htv.fi>
 <20130306014028.GA11205@balto.lan>
 <20130306085446.GI28587@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130306085446.GI28587@arwen.pp.htv.fi>
X-Operating-System: Linux balto 3.8.0-09633-g2a7d2b9 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 10:54:46AM +0200, Felipe Balbi wrote:
> > > are you sure this is correct ? you're not doing anything in case of
> > > vbus event. Shouldn't you make sure your vbus is off ?
> > 
> > The implementation I'm taking as reference for this patches does not do
> > anything on VBUS event and as I can see from commmit history, it has
> > been based on the omap2430 one, that in turns used to just run phy_init
> > - and that's not implemented.  But...
> > 
> > > What if your user uses a non-standard cable which has id-pin grounded
> > > on both sides ?
> > 
> > A cable with two micro/mini connectors with grounded IDs?  Did you ever
> > encountered such a thing?  I guess a ux500_musb_set_vbus(musb, 0) would
> 
> in fact, no...
> 
> > not hurt in that case.
> 
> right, just to be sure. Maybe I should fix omap2430 as well. I'll add it
> to my TODO list.

Fair enough, I'll send a v2 of this patch with the added vbus-off as
soon as I manage to test it.

Thanks,
Fabio

-- 
Fabio Baltieri
