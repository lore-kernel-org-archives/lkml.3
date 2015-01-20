Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbbATPFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:05:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57475 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751501AbbATPFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:05:07 -0500
Date: Tue, 20 Jan 2015 16:05:01 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3 2/8] mfd: Add atmel-st driver
Message-ID: <20150120150501.GH5014@piout.net>
References: <1421077023-30954-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421077023-30954-3-git-send-email-alexandre.belloni@free-electrons.com>
 <20150119094224.GJ21886@x1>
 <20150119225923.GG5014@piout.net>
 <20150120094739.GM5767@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120094739.GM5767@x1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/2015 at 09:47:39 +0000, Lee Jones wrote :
> > > This driver looks pretty pointless.  Why can't you request the sysconf
> > > registers from within the drivers themselves?
> > > 
> > 
> > How would you probe the watchdog driver then? Would you had the
> > "atmel,at91rm9200-st" compatible there?
> > 
> > At some point in time, we should add the reset driver, would you also
> > match it on "atmel,at91rm9200-st"?
> > 
> > I'm fine with that as this allows to avoid the mfd driver.
> 
> I'm sorry, I don't follow.  Why can't each driver have their own
> compatible strings?
> 

The same IP provides a clocksource, a watchdog and is also the reset
controller. I think that the DT guidelines requires that the DT
describes the hardware and so use one compatible for that IP;


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
