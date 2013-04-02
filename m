Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596Ab3DBHWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:22:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab3DBHWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:22:43 -0400
Subject: Re: gpio-ucb1400
From: Jean Delvare <jdelvare@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marek Vasut <marek.vasut@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <20130401153247.GA13517@sirena.org.uk>
References: <1364586399.4216.312.camel@amber.site>
	 <201303302020.44584.marek.vasut@gmail.com>
	 <20130330232559.GA12864@roeck-us.net>
	 <201303311919.06030.marek.vasut@gmail.com>
	 <1364814403.4943.7.camel@amber.site> <20130401153247.GA13517@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 02 Apr 2013 09:22:37 +0200
Message-ID: <1364887357.4208.6.camel@amber.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 01 avril 2013 à 16:32 +0100, Mark Brown a écrit :
> On Mon, Apr 01, 2013 at 01:06:43PM +0200, Jean Delvare wrote:
> 
> > My point was, the upstream gpio-ucb1400 driver in its current form is
> > unusable (on top of being ugly.) I have no doubt that someone used that
> > driver successfully in some external kernel tree, but the code that was
> > merged upstream is incomplete and no good.
> 
> What the driver is doing is, unfortunately, the best practice for an
> AC'97 connected device like this - we've got an uncomfortable mix of
> an enumerable bus and platform data combined with a subsystem which has
> never had enough love to work in a nice way with the kernel.  The idea
> is that any boards which have the device will call the _set_data()
> function in their board-specific code.

OK but where are these users? I can't see any in the upstream kernel.

> Sadly we're a little short on volunteers to clean up the AC'97
> subsystem so this situation shows little sign of improving.

Well Marek proposed a cleanup which looked good [1], several times
apparently, but it was never applied.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2010-October/028656.html

-- 
Jean Delvare
Suse L3

