Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaKKAAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 19:00:03 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:21079 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751138AbaKKAAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 19:00:00 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Lcm+eaCEGdVsy1tRaqZhp
Date: Mon, 10 Nov 2014 15:59:14 -0800
From: Tony Lindgren <tony@atomide.com>
To: =?utf-8?B?0JXQstCz0LXQvdC40Lkg0J/QvtC70Y/QutC+0LI=?= 
	<zbr@ioremap.net>
Cc: NeilBrown <neilb@suse.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        GTA04 owners <gta04-owner@goldelico.com>
Subject: Re: [PATCH] w1: omap-hdq: support device probing with device-tree.
Message-ID: <20141110235914.GH31454@atomide.com>
References: <20141108103032.5426db7a@notabene.brown>
 <17841415578204@web5g.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17841415578204@web5g.yandex.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Евгений Поляков <zbr@ioremap.net> [141109 16:11]:
> Hi
> 
> 08.11.2014, 02:30, "NeilBrown" <neilb@suse.de>:
> > This driver has no 'compatible' string and so is not found when
> > using device-tree.
> >
> > Add one with value to match
> >                 hdqw1w: 1w@480b2000 {
> > device in omap3.dtsi.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> 
> Looks good to me
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Applying into omap-for-v3.19/drivers branch thanks.

Tony
