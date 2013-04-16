Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798Ab3DPJxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:53:42 -0400
Received: from sauhun.de ([89.238.76.85]:57694 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379Ab3DPJxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:53:40 -0400
Date: Tue, 16 Apr 2013 11:53:09 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Kevin Strasser <kevin.strasser@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Michael Brunner <michael.brunner@kontron.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>, Michael Brunner <mibru@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/4] i2c: Kontron PLD i2c bus driver
Message-ID: <20130416095309.GD16978@the-dreams.de>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1365441321-21952-2-git-send-email-kevin.strasser@linux.intel.com>
 <20130410170212.GB19533@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410170212.GB19533@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 10:02:12AM -0700, Guenter Roeck wrote:
> On Mon, Apr 08, 2013 at 10:15:19AM -0700, Kevin Strasser wrote:
> > From: Michael Brunner <michael.brunner@kontron.com>
> > 
> > Add i2c support for the on-board PLD found on some Kontron embedded
> > modules.
> > 
> > Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> > Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> 
> Overall well written, though I have a couple of nitpicks.
> 
> I would prefer two separate drivers, one for the mux and one for the i2c bus.
> If that is possible, it would help getting rid of the #ifdef in the code, which
> is frowned upon in the kernel.
> 
> I dislike unnecessary ( ). Maintainer's call, though.
> 
> Couple of places have missing spaces around operators (checkpatch doesn't catch
> all those).
> 
> As far as I know, devm_ functions are supposed to print an error message on
> failure, so it should be unnecessary to print another one if that happens (this
> might need some confirmation).

Haven't done a full review due to tglx NACK. I agree to the points
mentioned here by Guenter, though.

