Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaI2MYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:24:19 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:50149 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaI2MYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:24:18 -0400
Date: Mon, 29 Sep 2014 13:24:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v3] watchdog: add driver for Ricoh RN5T618 watchdog
Message-ID: <20140929122411.GE7308@lee--X1>
References: <1411943987-30738-1-git-send-email-b.galvani@gmail.com>
 <20140929063407.GQ26868@spo001.leaseweb.com>
 <20140929075845.GD7308@lee--X1>
 <20140929105120.GA32092@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140929105120.GA32092@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014, Beniamino Galvani wrote:

> On Mon, Sep 29, 2014 at 08:58:45AM +0100, Lee Jones wrote:
> > I'm not sure why a) this patch was sent to me in the first place and
> > b) why anyone would think this should go in through MFD?
> > 
> 
> Hi Lee,
> 
> from a previous mail [1] I (wrongly) assumed that this was going
> through the MFD tree. If this is not the case, Wim, can you pick the
> patch?
> 
> Beniamino
> 
> [1] https://lkml.org/lkml/2014/9/4/124

Okay, I see what's happened.

So actually if there are interdependencies between this and the other
patches in the set, which I think there are, then you should have kept
this in the set with the others.  Sending as an independent patch is
not the correct thing to do.

Can you resend this, as a patch-set with all of the Acks you have
acquired please.  I will then take the set as a whole.

> > > You have my Acked-by or Signbed-off-by on this one.
> > > I believe this goes via the mfd tree.
> > 
> > Wim,
> > 
> > When you Ack something, you should add your full Acked-by string.
> > 
> > Patches should only be Signed-off(-by) when you are part of the
> > distribution path i.e. when you send patches to another Maintainer
> > and/or Linus.
> > 
> > > > This adds a driver for the watchdog timer available in Ricoh RN5T618
> > > > PMIC. The device supports a programmable expiration time of 1, 8, 32
> > > > or 128 seconds.
> > > > 
> > > > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> > > > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> > > > ---
> > > > 
> > > > Hi,
> > > > 
> > > > this is the third version of Ricoh RN5T618 watchdog driver. The other
> > > > patches of the original series adding MFD and regulator support have
> > > > already been merged.
> > > > 
> > > > Changes since v2 (http://lwn.net/Articles/610000/ ):
> > > >   - rename 'heartbeat' module parameter to 'timeout'
> > > >   - change parameter type to uint
> > > > 
> > > > Changes since v1:
> > > >   - initialized heartbeat parameter to 0 instead of -1
> > > >   - simplified code path in set_timeout function
> > > >   - fixed module unloading
> > > >   - made 'time' unsigned in struct rn5t618_wdt_map

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
