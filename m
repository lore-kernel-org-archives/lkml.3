Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaFWVNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:13:38 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:40671 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753945AbaFWVNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:13:37 -0400
Date: Mon, 23 Jun 2014 23:13:24 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog driver
Message-ID: <20140623211323.GA28120@spo001.leaseweb.com>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com> <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com> <20140507213318.GA2105@roeck-us.net> <20140515091123.GQ29258@lukather> <20140519150422.GA27329@lukather> <20140522203444.GE27329@lukather> <20140522211207.GA28704@roeck-us.net> <20140623103142.GB19730@lukather>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623103142.GB19730@lukather>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

> > > Guenter, since you seem to be the only responsive, may I suggest that
> > > you start merging patches and do a pull request to either Wim or Linus
> > > directly during the merge window?
> > > 
> > I had prepared a pull request for Wim last weekend or so, but then there
> > were more patches piling in and I got distracted, so I didn't have time
> > to actually send it. I'll try again this weekend ... the kids should be
> > busy learning for their finals, and I'll have Friday and Monday off
> > from work, so I should be able to find the time.
> > 
> > As for sending patches to Linus directly, well, Wim is the watchdog maintainer.
> > I manage to upset enough people, and would not want to add Wim to the list.
> > 
> > The patches _are_ in my watchdog-next branch and get some coverage from
> > both my auto-builders and from Fenguang's build robots, so while they are
> > not in linux-next, they are not completely in the dark either.
> 
> So, this patch finally didn't make it into 3.16. Great. Now, we can't
> even reboot the boards.

1) For me the discussion was not ended and needs further thinking. (And I just read some good ideas about it).
2) You never mentioned you needed this in for 3.16 and that things would break because of it.

So based on these 2 points why would I have to have put this in allready?

> Given how it's just impossible to get something merged reliably
> through the watchdog tree, I guess I should just start merging the
> patches through mine?

I agree that I have the problem of having only 24 hours in a day and that I lack time to communicate and that I am not good at communicating either, but I checked all sunxi related e-mails and you never mentioned the constraint to have it in for 3.16...
But I do understand your frustration.

Kind regards,
Wim.

