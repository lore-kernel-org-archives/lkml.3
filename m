Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaI2TSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:18:49 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:46834 "EHLO
	spo001.leaseweb.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754053AbaI2TSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:18:48 -0400
Date: Mon, 29 Sep 2014 21:18:44 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v3] watchdog: add driver for Ricoh RN5T618 watchdog
Message-ID: <20140929191844.GT26868@spo001.leaseweb.com>
References: <1411943987-30738-1-git-send-email-b.galvani@gmail.com> <20140929063407.GQ26868@spo001.leaseweb.com> <20140929075845.GD7308@lee--X1> <20140929105120.GA32092@gmail.com> <20140929122411.GE7308@lee--X1> <20140929165052.GA2085@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929165052.GA2085@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Beniamino,

> On Mon, Sep 29, 2014 at 01:24:11PM +0100, Lee Jones wrote:
> > On Mon, 29 Sep 2014, Beniamino Galvani wrote:
> > 
> > > On Mon, Sep 29, 2014 at 08:58:45AM +0100, Lee Jones wrote:
> > > > I'm not sure why a) this patch was sent to me in the first place and
> > > > b) why anyone would think this should go in through MFD?
> > > > 
> > > 
> > > Hi Lee,
> > > 
> > > from a previous mail [1] I (wrongly) assumed that this was going
> > > through the MFD tree. If this is not the case, Wim, can you pick the
> > > patch?
> > > 
> > > Beniamino
> > > 
> > > [1] https://lkml.org/lkml/2014/9/4/124
> > 
> > Okay, I see what's happened.
> > 
> > So actually if there are interdependencies between this and the other
> > patches in the set, which I think there are, then you should have kept
> > this in the set with the others.  Sending as an independent patch is
> > not the correct thing to do.
> > 
> > Can you resend this, as a patch-set with all of the Acks you have
> > acquired please.  I will then take the set as a whole.
> 
> The original series had 4 patches:
> 
> - MFD core support
> - regulator driver
> - watchdog driver
> - dts documentation
> 
> As explained in the submission comment, all patches except watchdog
> one have already been applied (1 and 4 to MFD tree, 2 to
> regulator). Only the watchdog support is missing and it doesn't have
> compilation dependencies to other patches (the watchdog driver can't
> be enabled without the MFD core support).
> 
> Do you want me to resend the entire patchset or should this go in
> through watchdog?

I'll add it to the watchdog tree then.

Kind regads,
Wim.

