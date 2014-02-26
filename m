Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaBZAKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:10:03 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22213 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaBZAKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:10:00 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX193XaGhgz5p99H4uRNbidEPFaIW2iq/1CM=
X-DKIM: OpenDKIM Filter v2.0.1 titan 59B2C533FBD
Date: Tue, 25 Feb 2014 19:09:40 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 00/10] pinctrl: mvebu: remove hard-coded addresses from
 Dove pinctrl
Message-ID: <20140226000940.GF1872@titan.lakedaemon.net>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140224181023.GA1010@titan.lakedaemon.net>
 <CACRpkdZ+YGTyDj6i8c198MdRtz3GY-YBmVO9LysPCcmT4EC0cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ+YGTyDj6i8c198MdRtz3GY-YBmVO9LysPCcmT4EC0cg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Tue, Feb 25, 2014 at 10:36:54AM +0100, Linus Walleij wrote:
> On Mon, Feb 24, 2014 at 7:10 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> 
> > Sebastian, Linus,
> >
> > I've now created mvebu/pinctrl-dove for this series.  It's based on
> > v3.14-rc1, and depends on mvebu/pinctrl (which depends on
> > mvebu/pinctrl-3xx).
> >
> > I've kept this series in a separate branch in case we encounter an
> > unforeseen problem with something in here.  Then this branch can be
> > dropped, and /pinctrl-3xx and /pinctrl will still make it in.
> >
> > So, all patches except 3 and 4 are in mvebu/pinctrl-dove.  3 and 4 are
> > in mvebu/dt.
> 
> OK so what should I be pulling in first now?

Sebastian has now re-organized the branches as I asked, and I confirmed
that the final result is the exact same as mine (diff is null).

Usually when I submit pull requests to arm-soc, they like to see the
branches.  That way if there is an error in one of them, they just drop
the one branch and the others remain.

Would you like them the same way?  If so, I'll send the pulls to you
tomorrow.  Otherwise, I'll wait a few more days to let things shake out
and then send you one request with the branches merged.

thx,

Jason.
