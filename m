Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3BKVAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 16:00:49 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:34372 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759272Ab3BKVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 16:00:48 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19U+WLWSi9RfqhIef+DA12c
Date: Mon, 11 Feb 2013 13:00:42 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Laurent Meunier <laurent.meunier@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl/pinconfig: add debug interface
Message-ID: <20130211210041.GW4801@atomide.com>
References: <1360527070-18430-1-git-send-email-linus.walleij@stericsson.com>
 <51195A63.7080706@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51195A63.7080706@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [130211 12:57]:
> On 02/10/2013 01:11 PM, Linus Walleij wrote:
> > From: Laurent Meunier <laurent.meunier@st.com>
> > 
> > This update adds a debugfs interface to modify a pin configuration
> > for a given state in the pinctrl map. This allows to modify the
> > configuration for a non-active state, typically sleep state.
> > This configuration is not applied right away, but only when the state
> > will be entered.
> > 
> > This solution is mandated for us by HW validation: in order
> > to test and verify several pin configurations during sleep without
> > recompiling the software.
> 
> I never understood why HW engineers can't just recompile the kernel.
> Besides, it's just a device tree change these days - no recompile even
> required, right?

Typically when bringing up a new board you do not have the driver
specific mux settings verified. For developers, it's easiest to tweak
the muxing during runtime do the drivers as a loadable module, then
export the verified mux configuration into a .dts file.

Regards,

Tony
