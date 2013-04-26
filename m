Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab3DZTTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:19:31 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35749 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499Ab3DZTT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:19:28 -0400
Date: Fri, 26 Apr 2013 11:30:39 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Simon Glass <sjg@chromium.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        lk <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        linux-pm@vger.kernel.org, Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH v8 0/3] Runtime Interpreted Power Sequences
Message-ID: <20130426183038.GA26373@teo>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
 <CAPnjgZ1P6dmRB0sO2qBUtd=WBiNcY339NAit2faaotAfEqQDeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPnjgZ1P6dmRB0sO2qBUtd=WBiNcY339NAit2faaotAfEqQDeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 11:55:35AM -0700, Simon Glass wrote:
> On Thu, Nov 15, 2012 at 10:38 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> > Hopefully the final series before the feature gets merged. Anton Vorontsov
> > kindly accepted to take it into his tree, so this series is mostly a call for
> > acks, tests and reviews notices before the merge window for 3.8 opens. If you
> > are interested in seeing this feature, please add your name.
> >
> > This series also adds an entry for the subsystem into MAINTAINERS, setting me as
> > the person in charge.
> >
> > Changes from v7:
> > - fix bug reported by Tony Prisk
> > - add MAINTAINERS entry
> >
> > Alexandre Courbot (3):
> >   Runtime Interpreted Power Sequences
> >   pwm_backlight: use power sequences
> >   Take maintainership of power sequences
> 
> Did this actually land?

At least not through my tree. I saw a huge discussion, and I am not sure
how it ended and whether there was a consensus.

Thanks,

Anton
