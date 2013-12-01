Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3LAW0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 17:26:12 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53226 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3LAW0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 17:26:07 -0500
Date: Sun, 1 Dec 2013 14:20:58 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "freemangordon@abv.bg" <freemangordon@abv.bg>,
        "aaro.koskinen@iki.fi" <aaro.koskinen@iki.fi>,
        "pavel@ucw.cz" <pavel@ucw.cz>
Subject: Re: [PATCH v2 1/3] power_supply: Add power_supply notifier
Message-ID: <20131201222057.GA22142@lizard>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-2-git-send-email-pali.rohar@gmail.com>
 <20ADAB092842284E95860F279283C5640AAF43B1@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20ADAB092842284E95860F279283C5640AAF43B1@BGSMSX104.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 05:23:34PM +0000, Tc, Jenny wrote:
> 
> > Subject: [PATCH v2 1/3] power_supply: Add power_supply notifier
> > 
> > This patch adds a notifier chain to the power_supply.
> > This notifier helps drivers in other subsystem to listen to changes in power supply
> > subsystem. This would help to take some actions in those drivers on changing the power
> > supply properties.
> > One such scenario is to increase/decrease system performance based on the battery
> > capacity/voltage. Another scenario is to adjust the h/w peak current detection
> > voltage/current thresholds based on battery voltage/capacity. The notifier helps drivers to
> > listen to changes in power_suppy susbystem without polling the power_supply properties
> > 
> > Signed-off-by: Jenny TC <jenny.tc@intel.com>
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > ---
> 
> Acked-by: Jenny TC <jenny.tc@intel.com>

Applied, thanks a lot!

Anton
