Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3ALWa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 17:30:56 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:53007 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754351Ab3ALWaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 17:30:55 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ebHgr5ovI7n5RCSXSpyj0vGwJKfKmKmE=
Date: Sat, 12 Jan 2013 17:30:50 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Dove: move CuBox led pinctrl to gpio-leds node
Message-ID: <20130112223050.GI13433@titan.lakedaemon.net>
References: <1356646870-2903-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130112214257.GF13433@titan.lakedaemon.net>
 <50F1DAE7.4050508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F1DAE7.4050508@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 10:51:35PM +0100, Sebastian Hesselbarth wrote:
> On 01/12/2013 10:42 PM, Jason Cooper wrote:
> >On Thu, Dec 27, 2012 at 11:21:10PM +0100, Sebastian Hesselbarth wrote:
> >>gpio-leds has support for pinctrl allocation, make use of it.
> >>
> >>Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> >> ...
> >>  &pinctrl {
> >>-	pinctrl-0 =<&pmx_gpio_12&pmx_gpio_18>;
> >>+	pinctrl-0 =<&pmx_gpio_12>;
> >>  	pinctrl-names = "default";
> >>
> >>  	pmx_gpio_12: pmx-gpio-12 {
> >>--
> >>1.7.10.4
> >
> >I'm getting a merge conflict wit hthe above:
> >
> >&pinctrl {
> ><<<<<<<  HEAD
> >         pinctrl-0 =<&pmx_gpio_18>;
> >=======
> >         pinctrl-0 =<&pmx_gpio_12>;
> >>>>>>>>ARM: Dove: move CuBox led pinctrl to gpio-leds node
> >         pinctrl-names = "default";
> >
> >         pmx_gpio_18: pmx-gpio-18 {
> >                 marvell,pins = "mpp18";
> >                 marvell,function = "gpio";
> >         };
> >};
> >
> >Am I missing something?
> 
> Jason,
> 
> it depends on "ARM: Dove: move CuBox led pinctrl to gpio-leds node"
> that you applied to mvebu/fixes two days ago.

Ahhh, ok, I'll include it in this pull.

thx,

Jason.
