Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaFWVXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:23:24 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:40687 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751407AbaFWVXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:23:23 -0400
Date: Mon, 23 Jun 2014 23:16:10 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog driver
Message-ID: <20140623211610.GB28120@spo001.leaseweb.com>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com> <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com> <20140507213318.GA2105@roeck-us.net> <20140515091123.GQ29258@lukather> <20140519150422.GA27329@lukather> <20140522203444.GE27329@lukather> <20140522213943.7649e304@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522213943.7649e304@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> On Thu, 22 May 2014 22:34:44 +0200
> Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
> 
> > On Mon, May 19, 2014 at 05:04:22PM +0200, Maxime Ripard wrote:
> > > On Thu, May 15, 2014 at 11:11:23AM +0200, Maxime Ripard wrote:
> > > > On Wed, May 07, 2014 at 02:33:18PM -0700, Guenter Roeck wrote:
> > > > > On Tue, May 06, 2014 at 09:44:19PM -0500, Maxime Ripard wrote:
> > > > > > Most of the watchdog code is duplicated between the machine restart code and
> > > > > > the watchdog driver. Add the restart hook to the watchdog driver, to be able to
> > > > > > remove it from the machine code eventually.
> > > > > > 
> > > > > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > > > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > > > 
> > > > > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> > > > 
> > > > Wim, do you have any comment on this one?
> > > 
> > > Ping?
> > > 
> > > It would be really great to see this in 3.16, and we get quite close
> > > to the end of ARM's merge window.
> > 
> > Ping?
> > 
> > Guenter, since you seem to be the only responsive, may I suggest that
> > you start merging patches and do a pull request to either Wim or Linus
> > directly during the merge window?
> 
> I've yet to see anyone explain why this is an improvement over the
> current situation ?

To move forward: can you share your objections with us again?

Thanks,
Wim.

