Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaJIRuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:50:08 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49931 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaJIRuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:50:03 -0400
Date: Thu, 9 Oct 2014 10:49:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, atull@opensource.altera.com
Subject: Re: [PATCH] regulator: of: Lower the severity of the error with no
 container
Message-ID: <20141009174958.GA4396@roeck-us.net>
References: <1412806199-5363-1-git-send-email-broonie@kernel.org>
 <20141008223403.GA24828@roeck-us.net>
 <20141008223601.GP4609@sirena.org.uk>
 <20141008225912.GA25134@roeck-us.net>
 <20141008234541.GQ4609@sirena.org.uk>
 <20141009000555.GA27476@roeck-us.net>
 <20141009001213.GS4609@sirena.org.uk>
 <20141009002531.GA27920@roeck-us.net>
 <20141009155440.GV4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009155440.GV4609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 04:54:40PM +0100, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 05:25:31PM -0700, Guenter Roeck wrote:
> 
> > > Shove a dev_name() on the front if we get a collision?  I have to say
> > > I've never cared, the debugfs isn't that important so it doesn't matter
> > > too much if it fails.
> 
> > Sure, but, again, I am getting lots and lots of those error messages.
> > I probably would not care either (and probably not even have noticed)
> > if not for those messages.
> 
> > Want me to submit a patch with the dev_name solution ?
> 
> Yes, please.

Turns out that is already supposed to happen if the function creating
the entry knows about the device. I guess this explains why others don't
see the problem. We'll have to find out what is going on.

Guenter
