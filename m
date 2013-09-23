Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3IWXL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 19:11:26 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47954 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753029Ab3IWXLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 19:11:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+yL7tT+MPK1Ct1B25YQYZG
Date: Mon, 23 Sep 2013 16:11:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz
Subject: Re: [PATCH 4/4] RX-51: Add platform function and data for bq24150a
 charger
Message-ID: <20130923231119.GK2684@atomide.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201309232116.19161@pali>
 <20130923200008.GA21808@earth.universe>
 <201309232206.47391@pali>
 <20130923204714.GB22995@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130923204714.GB22995@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@ring0.de> [130923 13:55]:
> On Mon, Sep 23, 2013 at 10:06:46PM +0200, Pali Rohár wrote:
> > On Monday 23 September 2013 22:00:09 Sebastian Reichel wrote:
> > > On Mon, Sep 23, 2013 at 09:16:18PM +0200, Pali Rohár wrote:
> > > > It is not as simple as it looks. This is reason why I
> > > > submited this patch long time after I submited bq2415x
> > > > driver.
> > > > 
> > > > Problem is that for rx51 is needed specific function which
> > > > connect to two drivers (bq2415x and isp1704) plus it call
> > > > specific rx51 board functions.
> > > > 
> > > > Something which cannot be in DT (unless DT support C/ASM
> > > > code).
> > > 
> > > mh could isp1704 driver expose the data via the regulator
> > > framework?
> > 
> > No, isp1704 is power supply driver and export data via power 
> > supply (sysfs) interface. It is not regulator but charger driver.
> 
> well it does not charge the battery directly, but just provides a
> power line with 5 Volt and a specified amount of current to the
> system, doesn't it?
> 
> From my POV this is a candiate for the regulator framework:
> 
> https://www.kernel.org/doc/Documentation/power/regulator/overview.txt

Yes I think we should be able handle that rail with the
regulator framework.

Regards,

Tony
