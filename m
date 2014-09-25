Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaIYHeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:34:46 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.174]:18258 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbaIYHem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:34:42 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-5.tower-38.messagelabs.com!1411630474!9582486!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 25 Sep 2014 09:34:35 +0200
Date: Thu, 25 Sep 2014 10:26:12 +0200
From: Andreas Werner <andreas.werner@men.de>
To: Lee Jones <lee.jones@linaro.org>
CC: Guenter Roeck <linux@roeck-us.net>, Bryan Wu <cooloney@gmail.com>,
        Andreas Werner <andreas.werner@men.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, <lm-sensors@lm-sensors.org>,
        <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Subject: Re: [PATCH v6 0/4] Introduce MEN 14F021P00 BMC driver series
Message-ID: <20140925082611.GA967@awelinux>
References: <cover.1409161615.git.andreas.werner@men.de>
 <20140924144829.GK32069@lee--X1>
 <20140924154503.GA12403@roeck-us.net>
 <20140924161837.GA7113@lee--X1>
 <CAK5ve-+79oMf0vD-_gzWLPbvFi4ygd1q9pzTCHzzpsXVkjqP9Q@mail.gmail.com>
 <20140924165739.GA31578@roeck-us.net>
 <20140924184143.GC7113@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140924184143.GC7113@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 07:41:43PM +0100, Lee Jones wrote:
> On Wed, 24 Sep 2014, Guenter Roeck wrote:
> 
> > On Wed, Sep 24, 2014 at 09:33:32AM -0700, Bryan Wu wrote:
> > > On Wed, Sep 24, 2014 at 9:18 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > > > On Wed, 24 Sep 2014, Guenter Roeck wrote:
> > > >
> > > >> On Wed, Sep 24, 2014 at 03:48:29PM +0100, Lee Jones wrote:
> > > >> > Guenter, Bryan, Wim,
> > > >> >
> > > >> > The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:
> > > >> >
> > > >> >   Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)
> > > >> >
> > > >> > are available in the git repository at:
> > > >> >
> > > >> >   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-hwmon-leds-watchdog-v3.18
> > > >> >
> > > >> > for you to fetch changes up to 964356938fcd3c0001a786f55b9f0a0fbe47656a:
> > > >> >
> > > >> >   hwmon: (menf21bmc) Introduce MEN14F021P00 BMC HWMON driver (2014-09-24 15:36:33 +0100)
> > > >> >
> > > >> > ----------------------------------------------------------------
> > > >> > Immutable branch between MFD, HWMON, LEDs and Watchdog for v3.18
> > > >> >
> > > >> I assume you'll push it all through mfd, correct ?
> > > >
> > > > The idea is for all the affected Maintainers to pull this branch in to
> > > > their own trees.  If you guys don't, there will be a good chance of
> > > > conflict during the merge-window, which will subsequently upset Linus.
> > > >
> > > > So in answer to your question; yes I'll be taking this, but so should
> > > > each of you.
> > > >
> > > 
> > > Thanks for this, man. What am I going to do here? Need I pull in all
> > > the patches here into my LED tree or just one LED patch? I think if
> > > you push this for Linus through MFD tree, I don't need to pull it into
> > > my tree, right?
> > > 
> > I did
> > 
> > git remote add mfd git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git
> > git fetch --tags mfd
> > git merge mfd-hwmon-leds-watchdog-v3.18
> > 
> > in both my hwmon-next and watchdog-next branches. Both are currently building,
> > and already pushed into to my repository at kernel.org.
> > 
> > So, effectively, when I send my pull request to Linus, all patches from
> > mfd-hwmon-leds-watchdog-v3.18 will be included, ie the entire series.
> > The same will happen when Lee sends his pull request, and Wim, and you. 
> > I believe that is what Lee is asking for.
> 
> That's right.  It's not okay to break this branch up.  If it was, we
> would have been able to apply our respective components into our own
> trees from the beginning, but as there are interdependencies, breaking
> up the branch could have nasty consequences depending on the order in
> which they land in Mainline.  Most likely bisectability will be
> broken, which is not allowed.
> 

Hi,
please do not forget the MAINTAINERS Patch for this series.
I have send it last week attached to this series.

Thanks

Regards
Andy

> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

