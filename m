Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416Ab3E1OqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:46:00 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53040 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934359Ab3E1Op7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:45:59 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 28 May 2013 07:46:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [GIT PULL] hwmon fixes for 3.10-rc2
Message-ID: <20130528144624.GA20979@roeck-us.net>
References: <20130515133311.GA14411@roeck-us.net>
 <20130517115640.GA15916@roeck-us.net>
 <CAADWXX-LBwadvbDjPv2sN50BzcGjeewQGCYuz1Cy1-vadWznNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADWXX-LBwadvbDjPv2sN50BzcGjeewQGCYuz1Cy1-vadWznNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 06:25:55AM -0700, Linus Torvalds wrote:
> I'm going through my spam-box, and find this. Guenter, I don't know what
> you've done to piss off gmail, but you should take a look at your email
> setup, because if gmail thinks you send spam, I'll have a hard time ever
> seeing your messages (and I don't go through spam very often)
> 
Guess that explains it. Thanks a lot for the note.

Too much spam out there lately, and small providers (like mine) get caught in
the middle. I tried AT&T / Yahoo, but they tend to reject patch series
as spam. So looks like I am caught between a rock and a hard place. On top
of that there is Google and its policies, which seem to target small providers;
I can not send any e-mail to a Google recipient (anyone@google.com) when using
my primary provider. One has to wonder if there is a conflict of interest
somewhere.

Guenter

>           Linus
> 
> 
> On Fri, May 17, 2013 at 4:56 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > Hi Linus,
> >
> > I noticed that you did not pull this series of patches.
> >
> > Did it get lost, is something wrong with it, or am I just impatient ?
> >
> > Thanks,
> > Guenter
> >
> > On Wed, May 15, 2013 at 06:33:11AM -0700, Guenter Roeck wrote:
> > > Hi Linus,
> > >
> > > Please pull hwmon fixes for Linux 3.10-rc2 from signed tag:
> > >
> > >     git://
> > git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.githwmon-for-linus
> > >
> > > Thanks,
> > > Guenter
> > > ------
> > >
> > > The following changes since commit
> > f722406faae2d073cc1d01063d1123c35425939e:
> > >
> > >   Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)
> > >
> > > are available in the git repository at:
> > >
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.gittags/hwmon-for-linus
> > >
> > > for you to fetch changes up to ecacb0b17c08fae89f65468727f0e4b8e91da4e1:
> > >
> > >   hwmon: fix error return code in abituguru_probe() (2013-05-13 08:07:13
> > -0700)
> > >
> > > ----------------------------------------------------------------
> > > Error path fixes for abituguru and iio_hwmon drivers.
> > > Drop erroneously created attributes from nct6775 driver.
> > >
> > > ----------------------------------------------------------------
> > > Axel Lin (2):
> > >       hwmon: (iio_hwmon) Fix missing iio_channel_release_all call if
> > devm_kzalloc fail
> > >       hwmon: (iio_hwmon) Fix null pointer dereference
> > >
> > > Guenter Roeck (1):
> > >       hwmon: (nct6775) Do not create non-existing attributes
> > >
> > > Wei Yongjun (1):
> > >       hwmon: fix error return code in abituguru_probe()
> > >
> > >  drivers/hwmon/abituguru.c |   16 ++++++++++------
> > >  drivers/hwmon/iio_hwmon.c |    8 +++++---
> > >  drivers/hwmon/nct6775.c   |    6 ++++--
> > >  3 files changed, 19 insertions(+), 11 deletions(-)
> >
> >
> >
> > > _______________________________________________
> > > lm-sensors mailing list
> > > lm-sensors@lm-sensors.org
> > > http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
> >
> >
