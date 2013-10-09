Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3JIPK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:10:26 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14853 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3JIPKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:10:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/jIGtiya/nxUH7e+7+sv+h
Date: Wed, 9 Oct 2013 08:10:15 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 3/6] pinctrl: single: Prepare for supporting SoC
 specific features
Message-ID: <20131009151015.GZ8313@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
 <20131003054218.8941.19273.stgit@localhost>
 <20131007173531.GX8949@atomide.com>
 <CACRpkdZ1CeSXJngo0gKpnag-=mT3FB-byJi3JSAWiS8hbHqBJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ1CeSXJngo0gKpnag-=mT3FB-byJi3JSAWiS8hbHqBJA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [131009 06:51]:
> On Mon, Oct 7, 2013 at 7:35 PM, Tony Lindgren <tony@atomide.com> wrote:
> 
> > Hi Linus W,
> >
> > Any comments on the pinctrl patches 3 - 5 in this series?
> 
> Yes, after good explanations to my whimsical questions only this:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

OK thanks :)
 
> I guess you'll take these patches through ARM SoC?

I was thinking I'll set up an immutable branch for the three
pinctrl patches against -rc4 then both you and I can merge
them in as needed. Does that work for you?

I can also do a test merge with pinctrl/for-next also to make
sure there are no conflicts.

The rest of the patches should not be needed in the pinctrl
branch, but I need them all in one branch to keep things
working.

Regards,

Tony
