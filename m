Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3EZOjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 10:39:00 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48064 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753217Ab3EZOi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 10:38:59 -0400
Date: Sun, 26 May 2013 16:38:56 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Kevin Strasser <kevin.strasser@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Michael Brunner <michael.brunner@kontron.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-watchdog@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>,
        Michael Brunner <mibru@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/4] watchdog: Kontron PLD watchdog timer
Message-ID: <20130526143856.GC7603@spo001.leaseweb.com>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com> <1365441321-21952-4-git-send-email-kevin.strasser@linux.intel.com> <20130410164717.GA19533@roeck-us.net> <20130410165733.GA2769@wrk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410165733.GA2769@wrk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

> On Wed, Apr 10, 2013 at 09:47:17AM -0700, Guenter Roeck wrote:
> > On Mon, Apr 08, 2013 at 10:15:21AM -0700, Kevin Strasser wrote:
> > > From: Michael Brunner <michael.brunner@kontron.com>
> > > 
> > > Add watchdog timer support for the on-board PLD found on some Kontron
> > > embedded modules.
> > > 
> > > Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> > > Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> > 
> > Personally I would prefer two separate patches for the two drivers,
> > and to have the drivers converted to the watchdog infrastructure.
> > Wim's call, of course.
> > 
> Thanks for the feedback. I'm happy to do both if Wim thinks it's
> necessary.

Yes, 2 patches with conversion to the new watchdog infrastructure please.

Kind regards,
Wim.

