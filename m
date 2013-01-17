Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3AQKry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:47:54 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:44879 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3AQKrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:47:52 -0500
Date: Thu, 17 Jan 2013 10:47:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: davem@davemloft.net
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Robert Marklund <robert.marklund@stericsson.com>,
        linus.walleij@stericsson.com, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@linaro.org
Subject: Re: [PATCH 4/4 v3] net/smsc911x: Provide common clock functionality
Message-ID: <20130117104744.GP20091@gmail.com>
References: <20121220192441.GC14363@n2100.arm.linux.org.uk>
 <20121220203514.GN2691@gmail.com>
 <20121220205113.GD14363@n2100.arm.linux.org.uk>
 <20121221091306.GO2691@gmail.com>
 <20121221092421.GG14363@n2100.arm.linux.org.uk>
 <20121221114105.GP2691@gmail.com>
 <20130103111450.GC14714@gmail.com>
 <CACRpkda-4C+ezaZFSkxsNbmHnBN8RCoCeGePaOF-DzV0XnkzQw@mail.gmail.com>
 <20130109085555.GA31678@gmail.com>
 <CACRpkdY+C8jNT7LsJvBkauN4+x4k4gGJKSe0ynY_HLTpmpgFPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdY+C8jNT7LsJvBkauN4+x4k4gGJKSe0ynY_HLTpmpgFPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> > Some platforms provide clocks which require enabling before the
> >> > SMSC911x chip will power on. This patch uses the new common clk
> >> > framework to do just that. If no clock is provided, it will just
> >> > be ignored and the driver will continue to assume that no clock
> >> > is required for the chip to run successfully.
> >> >
> >> > Cc: Steve Glendinning <steve.glendinning@shawell.net>
> >> > Cc: netdev@vger.kernel.org
> >> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >>
> >> Looks all right to me now:
> >> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > I still need a maintiner Ack for this before I can push it.
> >
> > Anyone?
> 
> Steve is there sometimes. But I'd ask David Miller to ACK
> it if he's OK with the change.
> 
> Yours,
> Linus Walleij

Hi David,

Does this [1] patch look okay to you too?

It's the last Ack I require before I can push the set.

[1] https://patchwork.kernel.org/patch/1926971/

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
