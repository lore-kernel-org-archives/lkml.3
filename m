Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaHBPp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 11:45:26 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58533 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbaHBPpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 11:45:24 -0400
Date: Sat, 2 Aug 2014 08:45:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
Message-ID: <20140802154519.GA21259@roeck-us.net>
References: <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140507213318.GA2105@roeck-us.net>
 <20140515091123.GQ29258@lukather>
 <20140519150422.GA27329@lukather>
 <20140522203444.GE27329@lukather>
 <20140522211207.GA28704@roeck-us.net>
 <20140623103142.GB19730@lukather>
 <20140623211323.GA28120@spo001.leaseweb.com>
 <20140624144954.GP19730@lukather>
 <20140802080208.GA22804@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140802080208.GA22804@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 10:02:08AM +0200, Wim Van Sebroeck wrote:
> Maxime, All,
> 
> > > 1) For me the discussion was not ended and needs further
> > > thinking. (And I just read some good ideas about it).
> > 
> > It would have been great for you to mention it then.
> > 
> > > 2) You never mentioned you needed this in for 3.16 and that things
> > > would break because of it.
> > 
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/257690.html
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/259109.html
> > 
> > I thought it was pretty clear.
> > 
> 
> I will put it in now as step in between before going over to the new restart system.
> Anyone objections?
> 
Ok with me.

Guenter
