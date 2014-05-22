Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaEVUky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:40:54 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37478 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaEVUkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:40:53 -0400
Date: Thu, 22 May 2014 21:39:43 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: wim@iguana.be, Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
Message-ID: <20140522213943.7649e304@alan.etchedpixels.co.uk>
In-Reply-To: <20140522203444.GE27329@lukather>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
	<1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com>
	<20140507213318.GA2105@roeck-us.net>
	<20140515091123.GQ29258@lukather>
	<20140519150422.GA27329@lukather>
	<20140522203444.GE27329@lukather>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014 22:34:44 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

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

I've yet to see anyone explain why this is an improvement over the
current situation ?
