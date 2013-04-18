Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936391Ab3DRQmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:42:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39970 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936266Ab3DRQmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:42:18 -0400
Message-ID: <1366303337.2119.22.camel@joe-AO722>
Subject: Re: [PATCH 1/4] mfd: Kontron PLD mfd driver
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Kevin Strasser <kevin.strasser@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Michael Brunner <michael.brunner@kontron.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>, Michael Brunner <mibru@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 18 Apr 2013 09:42:17 -0700
In-Reply-To: <20130418133555.GA2767@roeck-us.net>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
	 <alpine.LFD.2.02.1304132152320.21884@ionos>
	 <20130418041940.GB7535@roeck-us.net> <1366260053.28609.66.camel@joe-AO722>
	 <20130418133555.GA2767@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-18 at 06:35 -0700, Guenter Roeck wrote:
> On Wed, Apr 17, 2013 at 09:40:53PM -0700, Joe Perches wrote:
> > On Wed, 2013-04-17 at 21:19 -0700, Guenter Roeck wrote:
> > > On Sat, Apr 13, 2013 at 10:38:07PM +0200, Thomas Gleixner wrote:
> > > > > + return kempld_read8(pld, index) | kempld_read8(pld, index+1) << 8;
> > > >                                                         index + 1)
> > > > Please
> > > Wondering .... why does checkpatch not report those ?
> > 
> > because checkpatch doesn't care about spacing around
> > arithmetic as long as it's consistent.
> > 
> > Documentation/CodingStyle doesn't say anything about
> > it either.
> > 
> Hi Joe,
> 
> "Use one space around (on each side of) most binary and ternary operators"
> 
> doesn't apply, then ? When does it apply ? I always thought it would apply
> to cases such as the above.

There's a _lot_ of code that doesn't follow the
"single space around binary operators" style,
it's contentious, and was determined when Andy
did the original checkpatch implementation to not
be a valuable addition or worth the complaint pain.


