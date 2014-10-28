Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaJ1Qxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:53:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:14377 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbaJ1Qxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:53:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,803,1406617200"; 
   d="scan'208";a="612875471"
Date: Tue, 28 Oct 2014 09:42:59 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] gpio/pinctrl: baytrail: move gpio driver from
 pinctrl to gpio directory
Message-ID: <20141028164259.GA16355@psi-dev26.jf.intel.com>
References: <1413227857-555-1-git-send-email-david.a.cohen@linux.intel.com>
 <543CFC7F.2070607@linux.intel.com>
 <20141014174535.GA6516@psi-dev26.jf.intel.com>
 <20141015070812.GM2255@lahna.fi.intel.com>
 <20141015165542.GA4529@psi-dev26.jf.intel.com>
 <20141016080123.GW2255@lahna.fi.intel.com>
 <20141017015322.GB4513@psi-dev26.jf.intel.com>
 <CACRpkdafsd3VDiEKbdooXx+mdAtf-3B6QBOEGeHgyJf9GKHqhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdafsd3VDiEKbdooXx+mdAtf-3B6QBOEGeHgyJf9GKHqhQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 04:10:26PM +0100, Linus Walleij wrote:
> On Fri, Oct 17, 2014 at 3:53 AM, David Cohen
> <david.a.cohen@linux.intel.com> wrote:
> > On Thu, Oct 16, 2014 at 11:01:23AM +0300, Mika Westerberg wrote:
> 
> >> In an ideal world, yes. However, the reality has shown that BIOS/FW gets
> >> these wrong and we need to work it around in the OS.
> >
> > But we never upstream these workarounds, right? :)
> 
> Unless you discover it after it hits the market, right?

This is quite unlikely to happen. A pin mux misconfigured would have
quite bad side effects. But considering it happens, IMHO not even this
case would make an upstreamed baytrail pinctrl API consumer correct. The
FW should get updated instead. But...

> 
> I think this driver is just fine exactly where it is. Besides, the driver
> is fully aware of all its pins, and just look at all the pull up etc
> information displayed by byt_gpio_dbg_show(), it doesn't get more
> pin control than that even if you don't implement the pin control
> API.

... considering the development boards + the case you mentioned above,
my RFC got more buried than it already was :)

Br, David

> 
> Yours,
> Linus Walleij
