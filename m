Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaB0PPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:15:00 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31991 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaB0PO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:14:58 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19cYzp3n7xqhYeOsFBZzCZ5CEPVxZnZMmw=
X-DKIM: OpenDKIM Filter v2.0.1 titan 938EE535746
Date: Thu, 27 Feb 2014 10:14:47 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 00/10] pinctrl: mvebu: remove hard-coded addresses from
 Dove pinctrl
Message-ID: <20140227151447.GI1872@titan.lakedaemon.net>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140224181023.GA1010@titan.lakedaemon.net>
 <CACRpkdZ+YGTyDj6i8c198MdRtz3GY-YBmVO9LysPCcmT4EC0cg@mail.gmail.com>
 <20140225151656.GI1010@titan.lakedaemon.net>
 <530CB725.5070904@gmail.com>
 <20140225154347.GJ1010@titan.lakedaemon.net>
 <530CEDB7.2070103@gmail.com>
 <20140225200447.GA1872@titan.lakedaemon.net>
 <20140227133831.GA28443@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227133831.GA28443@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 10:38:32AM -0300, Ezequiel Garcia wrote:
> On Tue, Feb 25, 2014 at 03:04:47PM -0500, Jason Cooper wrote:
> > On Tue, Feb 25, 2014 at 08:23:35PM +0100, Sebastian Hesselbarth wrote:
> > > [Cooked down Cc list to relevant people and added Ezequiel who agreed
> > > to test on Armada 375/38x.]
> > > 
> [..]
> > 
> > If you can drop the dtsi changes (I have them in mvebu/dt), and fix the
> > whitespace change, then we can merge them as is.
> > 
> 
> Tested for-next on Armada 375 and Armada 385 development boards. The
> pinctrl debugfs looks correct.
> 
> I've been using for-next for a couple days now, without issues.

Great!  Thanks, Ezequiel!

thx,

Jason.
