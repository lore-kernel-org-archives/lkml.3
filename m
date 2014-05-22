Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaEVVM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:12:27 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38334 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaEVVMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:12:25 -0400
Date: Thu, 22 May 2014 14:12:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: wim@iguana.be, Arnd Bergmann <arnd@arndb.de>, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
Message-ID: <20140522211207.GA28704@roeck-us.net>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140507213318.GA2105@roeck-us.net>
 <20140515091123.GQ29258@lukather>
 <20140519150422.GA27329@lukather>
 <20140522203444.GE27329@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522203444.GE27329@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 10:34:44PM +0200, Maxime Ripard wrote:
> On Mon, May 19, 2014 at 05:04:22PM +0200, Maxime Ripard wrote:
> > On Thu, May 15, 2014 at 11:11:23AM +0200, Maxime Ripard wrote:
> > > On Wed, May 07, 2014 at 02:33:18PM -0700, Guenter Roeck wrote:
> > > > On Tue, May 06, 2014 at 09:44:19PM -0500, Maxime Ripard wrote:
> > > > > Most of the watchdog code is duplicated between the machine restart code and
> > > > > the watchdog driver. Add the restart hook to the watchdog driver, to be able to
> > > > > remove it from the machine code eventually.
> > > > > 
> > > > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > > 
> > > > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> > > 
> > > Wim, do you have any comment on this one?
> > 
> > Ping?
> > 
> > It would be really great to see this in 3.16, and we get quite close
> > to the end of ARM's merge window.
> 
> Ping?
> 
> Guenter, since you seem to be the only responsive, may I suggest that
> you start merging patches and do a pull request to either Wim or Linus
> directly during the merge window?
> 
I had prepared a pull request for Wim last weekend or so, but then there
were more patches piling in and I got distracted, so I didn't have time
to actually send it. I'll try again this weekend ... the kids should be
busy learning for their finals, and I'll have Friday and Monday off
from work, so I should be able to find the time.

As for sending patches to Linus directly, well, Wim is the watchdog maintainer.
I manage to upset enough people, and would not want to add Wim to the list.

The patches _are_ in my watchdog-next branch and get some coverage from
both my auto-builders and from Fenguang's build robots, so while they are
not in linux-next, they are not completely in the dark either.

Guenter
