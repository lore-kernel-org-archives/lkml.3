Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3KNLNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:13:16 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54463 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785Ab3KNLNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:13:14 -0500
Date: Thu, 14 Nov 2013 11:12:45 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/5 v2] input: tc3589x-keypad: support probing from
 device tree
Message-ID: <20131114111245.GF16396@e106331-lin.cambridge.arm.com>
References: <1384265618-10590-1-git-send-email-linus.walleij@linaro.org>
 <20131112153057.GA9683@earth.universe>
 <CACRpkdb_bryGJo7CKGP5tj3RFGv=Gh+Q5m9ucVKqJ068tjPC2g@mail.gmail.com>
 <20131112200514.GA15413@earth.universe>
 <CACRpkdaAaLjm_b+OLj3tobxBN8YGUcTPnXJ=qtBqd02=FTxhjQ@mail.gmail.com>
 <20131112204013.GA17674@earth.universe>
 <20131113142406.GH21713@e106331-lin.cambridge.arm.com>
 <20131113232923.GB13669@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113232923.GB13669@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 11:29:24PM +0000, Sebastian Reichel wrote:
> Hi,
> 
> On Wed, Nov 13, 2013 at 02:24:06PM +0000, Mark Rutland wrote:
> > > Current suggestions (taken from kernel) are:
> > > 
> > > * <<vendor>>,no-autorepeat
> > > * keypad,autorepeat
> > > * linux,keypad-no-autorepeat
> > > * linux,input-no-autorepeat
> > > * linux,no-autorepeat
> > > * autorepeat
> > > 
> > > I do not really care, which one is chosen, except for two things:
> > > 
> > > * <<vendor>> seems wrong. This is not vendor specific.
> > > * I would prefer "input-" over "keypad-", since then the same name
> > >   can be used for single keys, buttons, etc.
> > 
> > Both of those sound valid to me, but I think it may make sense to keep
> > the "linux," prefix. As I understand it this is really telling the Linux
> > input subsystem to react to a device acting in a certain way, rather
> > than describing or configuring the device in a certain way.
> 
> That leaves the following two options:
> 
> * linux,input-no-autorepeat
> * linux,no-autorepeat
> 
> Any suggestions for those?

I'd go for "linux,input-no-autorepeat", it leaves less ambiguity as to
its purpose.

Mark.
