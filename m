Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaBXPFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:05:33 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57677 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752313AbaBXPFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:05:32 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/JGSIuoscP3cf6SPfGhET3mNvvbPYQvxk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 6B466532161
Date: Mon, 24 Feb 2014 10:05:21 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/16] pinctrl: mvebu: restructure resource
 allocation
Message-ID: <20140224150521.GD14250@titan.lakedaemon.net>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140223154053.GN7862@titan.lakedaemon.net>
 <CACRpkdZFwcFtZiDH792awhyrQ6wtEsJMMN9K_ypCbqLqZo9LLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZFwcFtZiDH792awhyrQ6wtEsJMMN9K_ypCbqLqZo9LLw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 11:22:51AM +0100, Linus Walleij wrote:
> On Sun, Feb 23, 2014 at 4:40 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> 
> > I certainly don't want to assume we can take this, and you've been quiet
> > on the previous versions of this series.  We have a lot of moving pieces
> > for getting the Armada 375/380/385 support added to the kernel.  It's a
> > huge help to us if we can create a topic branch for you with the pinctrl
> > changes in it.
> 
> I understand, sorry I was on a short vacation.

What?!  :)  I was just the opposite.  I've been laid up for five days
now after some minor surgery.  Nothing to do all day but bang away on my
laptop...  Which was actually perfect timing for the new SoCs and the
kirkwood migration.

> I've applied Thomas' two new SoC drivers and started queueing
> Sebastians series but it's a bit messy. Right now I'm not finding
> patch 06/21 v4....
> 
> >> https://github.com/shesselba/linux-dove.git unstable/mvebu-pinctrl-v3.14_v4
> 
> Should I just pull this in instead, as it contains both Thomas' and Sebastians
> patches, and then you can send me more stuff on top of that?

Please see my earlier reply to Thomas' 375/38x series.  I have it all
set up for you and will send pull requests  to you in a few days.

thx,

Jason.
