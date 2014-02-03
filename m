Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaBCW12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:27:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34774 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBCW11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:27:27 -0500
Date: Mon, 3 Feb 2014 14:27:26 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: Would devm_regulator_enable be useful ?
Message-ID: <20140203222726.GA5053@roeck-us.net>
References: <52ED901F.3010002@roeck-us.net>
 <20140203182152.GG22609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203182152.GG22609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 06:21:52PM +0000, Mark Brown wrote:
> On Sat, Feb 01, 2014 at 04:23:59PM -0800, Guenter Roeck wrote:
> 
> As previously mentioned please fix your mailer to word wrap at a
> sensible limit.
> 
I thought I did ;-). I'll try to make sure I only send e-mail to you
using mutt in the future ... but I notice that your line length is
less than the one I configured, so maybe that is the problem here.

> > Seems to me it would be useful to have it, but then devm_clk_enable()
> > doesn't exist either, so I wonder if there is a reason for not having
> > it.
> 
> In both cases enabling and then leaving the resource enabled throughout
> the runtime of the device isn't normally the best practice for using
> them.  You usually want to enable and disable at runtime with mechanisms
> like runtime PM when the device is idle rather than burning power all
> the time and once you start doing that managed resources don't fit so
> well.

Ok, I accept that. I thought that was what devm_xxx_[disable,remove] etc
was for, though.

Thanks,
Guenter
