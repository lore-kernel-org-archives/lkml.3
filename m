Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab3FQMEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:04:00 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:45348 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3FQMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:03:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 81.197.64.154
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/F37wAji+mLvaZWVxuG7sX
Date: Mon, 17 Jun 2013 05:03:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>, sudhakar.raj@ti.com
Subject: Re: [PATCH 01/11] pinctrl: single: adopt pinctrl sleep mode
 management
Message-ID: <20130617120340.GE10305@atomide.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
 <1369995191-20855-2-git-send-email-gururaja.hebbar@ti.com>
 <CACRpkdZjvW6M1Q+K3OD1x_Jkz91AofdOdBThyJLGJ+Wx-BDTNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZjvW6M1Q+K3OD1x_Jkz91AofdOdBThyJLGJ+Wx-BDTNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [130617 04:38]:
> On Fri, May 31, 2013 at 12:13 PM, Hebbar Gururaja
> <gururaja.hebbar@ti.com> wrote:
> 
> > Make pinctrl-single able to handle suspend/resume events and change
> > hogged pins states accordingly.
> >
> > Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> 
> Noone said anything about this patch, but it looks very straight-forward
> to me and seems sound so I have applied it.
> 
> If Tony or Haojian has strong feelings about it I will dequeue it.

I don't like the hogged pins at all as they prevent me from unloading
pinctrl-single.. But the patch seems fine to me:

Acked-by: Tony Lindgren <tony@atomide.com>
