Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaE1Rzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:55:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46557 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751158AbaE1Rzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:55:41 -0400
Date: Wed, 28 May 2014 19:55:35 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] misc: atmel_pwm: only build for supported platforms
Message-ID: <20140528175439.GA18470@piout.net>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-17-git-send-email-arnd@arndb.de>
 <536CA80A.60201@atmel.com>
 <1401279867.22486.6.camel@x220>
 <20140528155916.GA9793@piout.net>
 <1401293383.22486.18.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401293383.22486.18.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/2014 at 18:09:43 +0200, Paul Bolle wrote :
> On Wed, 2014-05-28 at 17:59 +0200, Alexandre Belloni wrote:
> > On 28/05/2014 at 14:24:27 +0200, Paul Bolle wrote :
> > > > >  config ATMEL_PWM
> > > > >  	tristate "Atmel AT32/AT91 PWM support"
> > > > > -	depends on HAVE_CLK && (AVR32 || ARCH_AT91 || COMPILE_TEST)
> > > > > +	depends on HAVE_CLK
> > > > > +	depends on AVR32 || AT91SAM9263 || AT91SAM9RL || AT91SAM9G45
> > > 
> > > Symbols AT91SAM9263, AT91SAM9RL, and AT91SAM9G45 do not seem to exist in
> > > next-20140528. Should these perhaps be SOC_AT91SAM9263, SOC_AT91SAM9RL,
> > > and SOC_AT91SAM9G45 and/or ARCH_AT91SAM9263, ARCH_AT91SAM9RL, and
> > > ARCH_AT91SAM9G45?
> > 
> > I wouldn't bother too much fixing that, this will definitely be remove
> > in 3.17. 
> 
> Are you talking about: 1) the problem this patch tried to fix; or 2) the
> problem it created?
> 

I'm removing the whole atmel_pwm driver so the CONFIG_ATMEL_PWM symbol
will be gone.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
