Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab3HZIw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:52:58 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32514 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751683Ab3HZIwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:52:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ITKb/HrR/qHnRQ/ACLg2I
Date: Mon, 26 Aug 2013 01:52:53 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Subject: Re: [PATCH 3/3] ARM: OMAP2+: Add SSI driver configuration
Message-ID: <20130826085252.GA7656@atomide.com>
References: <1376237628-1077-1-git-send-email-sre@debian.org>
 <1376237877-1740-1-git-send-email-sre@debian.org>
 <1376237877-1740-3-git-send-email-sre@debian.org>
 <20130812083051.GL7656@atomide.com>
 <CACRpkdbfGPx=j7byCdQV7Eghohr==mi+FyxSODE8kNTCgH-ayA@mail.gmail.com>
 <20130823182011.GC5753@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823182011.GC5753@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [130823 11:27]:
> On Fri, Aug 23, 2013 at 03:58:30PM +0200, Linus Walleij wrote:
> > On Mon, Aug 12, 2013 at 10:30 AM, Tony Lindgren <tony@atomide.com> wrote:
> > > * Sebastian Reichel <sre@debian.org> [130811 09:25]:
> > >> From: Sebastian Reichel <sre@ring0.de>
> > >>
> > >> This patch configures and activates the OMAP SSI driver on the RX-51.
> > >
> > > Hmm, I'd rather see this be DT only driver at this point.
> > 
> > +1 on this.
> 
> I'm already working on this.

Thanks good to hear!

Tony
