Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3IQXud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:50:33 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36879 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3IQXub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:50:31 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18bsiJ2MWYFRwamRNj6Cfpn
Date: Tue, 17 Sep 2013 16:50:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ADP1653 board code for Nokia RX-51
Message-ID: <20130917235028.GR9994@atomide.com>
References: <201302171616.50152@pali>
 <20130217190303.GC2317@blackmetal.musicnaut.iki.fi>
 <201303062112.06417@pali>
 <201309062234.05878@pali>
 <20130907230252.GA10700@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130907230252.GA10700@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Aaro Koskinen <aaro.koskinen@iki.fi> [130907 16:10]:
> Hi,
> 
> On Fri, Sep 06, 2013 at 10:34:05PM +0200, Pali Rohár wrote:
> > > --- /dev/null
> > > +++ b/arch/arm/mach-omap2/board-rx51-camera.c
> [...]
> > Ping, can you review this patch v2?
> 
> I don't think Tony will accept any new board stuff for RX-51/N900.
> See for example: http://marc.info/?l=linux-kernel&m=137629626213187&w=2
> 
> There should be initial Nokia N900 DTS file in 3.12-rc1, and we should
> continue converting this board fully to DT.

Yes let's plan on making mach-omap2 to be DT only soonish.
AFAIK the only stopper right now for omap3 are the pending
pinctrl changes for the wake-up events as otherwise we would
have sever PM regressions with off-idle.

Regards,

Tony
