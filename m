Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaCGNqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:46:33 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64827 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751646AbaCGNqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:46:30 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/+fD/fUmJlfkpclVkgj07vgCVpohMS2y0=
X-DKIM: OpenDKIM Filter v2.0.1 titan 22C0453CB36
Date: Fri, 7 Mar 2014 08:46:16 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] pinctrl: mvebu: silence WARN to dev_warn
Message-ID: <20140307134616.GR1872@titan.lakedaemon.net>
References: <1393977790-29110-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393977790-29110-4-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140306201803.GL1872@titan.lakedaemon.net>
 <CACRpkda0JCLZUv_KPmwucDh3ko2YbtG2ukMMscSodAbBpiY+zw@mail.gmail.com>
 <20140307035056.GQ1872@titan.lakedaemon.net>
 <CACRpkdbEQSj7jLWT2BFR22m7phwmyKCByhQuFFgHvHoKvQFD5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbEQSj7jLWT2BFR22m7phwmyKCByhQuFFgHvHoKvQFD5g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 11:56:11AM +0800, Linus Walleij wrote:
> On Fri, Mar 7, 2014 at 11:50 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > On Fri, Mar 07, 2014 at 11:48:25AM +0800, Linus Walleij wrote:
> >> On Fri, Mar 7, 2014 at 4:18 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> >> > On Wed, Mar 05, 2014 at 01:03:10AM +0100, Sebastian Hesselbarth wrote:
> >> >> Pinctrl will WARN on missing DT resources, which is a little bit too
> >> >> noisy. Use dev_warn with FW_BUG instead.
> >> >>
> >> >> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> >> >> ---
> >> >> Cc: Russell King <linux@arm.linux.org.uk>
> >> >> Cc: Jason Cooper <jason@lakedaemon.net>
> >> >> Cc: Andrew Lunn <andrew@lunn.ch>
> >> >> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> >> >> Cc: Linus Walleij <linus.walleij@linaro.org>
> >> >> Cc: devicetree@vger.kernel.org
> >> >> Cc: linux-arm-kernel@lists.infradead.org
> >> >> Cc: linux-kernel@vger.kernel.org
> >> >> ---
> >> >>  drivers/pinctrl/mvebu/pinctrl-dove.c | 3 ++-
> >> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >> >
> >> > Applied to mvebu/pinctrl
> >>
> >> So are you carrying this patch, or shall I apply it to my tree?
> >>
> >> In the former case: Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > I'll send you a pull tomorrow.
> 
> For a single patch?

Well, just the doc change and WARN change.  I've already taken the dts
change into mvebu/dt (for arm-soc).

There should be no need for these two to be in mvebu's for-next, so if
it's easier for you to pick them, please do so.

I'll drop them from mvebu/pinctrl and update mvebu's for-next right now.

thx,

Jason.
