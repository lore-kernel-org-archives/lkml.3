Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab3CaTkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 15:40:08 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:43140 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3CaTkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 15:40:06 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: gpio-ucb1400
Date: Sun, 31 Mar 2013 19:19:05 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Jean Delvare <jdelvare@suse.de>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1364586399.4216.312.camel@amber.site> <201303302020.44584.marek.vasut@gmail.com> <20130330232559.GA12864@roeck-us.net>
In-Reply-To: <20130330232559.GA12864@roeck-us.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303311919.06030.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Guenter Roeck,

> On Sat, Mar 30, 2013 at 08:20:44PM +0100, Marek Vasut wrote:
> > Dear Guenter Roeck,
> > 
> > > On Fri, Mar 29, 2013 at 08:46:39PM +0100, Jean Delvare wrote:
> > > > Hi all,
> > > > 
> > > > In September 2009, a driver for the GPIO function of the UCB1400 chip
> > > > was added to the kernel tree. The probe function of this driver
> > > > requires ucbdata to be set. The only place where this happens is in
> > > > function ucb1400_gpio_set_data(). This function was never call, and
> > > > still isn't. So this is dead code for 3.5 years as far as the
> > > > upstream kernel is concerned.
> > > > 
> > > > To make things worse, this driver can't be built as a module, for no
> > > > good reason that I can see.
> > > > 
> > > > Marek, can you explain what was the point of submitting this driver
> > > > that nobody can use?
> > > > 
> > > > I would like either this driver to be fixed so that it can be used
> > > > (and that would IMHO start with dropping the ugly
> > > > ucb1400_gpio_set_data hook and global variable ucbdata), or this
> > > > driver to be dropped from the kernel tree. If the driver is kept, it
> > > > should be adjusted so that it can be built as a module.
> > > > 
> > > > If I overlooked something, please let me know.
> > > 
> > > Interestingly, the author made an attempt to fix that with [1]. It
> > > looks like the rest of that series was merged, but this patch wasn't,
> > > though I don't find any information about the reason.
> > 
> > It's been a while. Guenter, thanks for finding that link, but I suspect
> > the patch is heavily obsolete by now.
> 
> Oh, it most definitely is, starting with the gpio driver name. Just wonder
> why it was never applied, and why no one seems to have noticed or cared.
> 
> Jean is absolutely right - it should get fixed, or the driver should be
> dropped if no one is using it anyway.

I think ARM/palmtc was using this.

Best regards,
Marek Vasut
