Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbaIRV5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:57:11 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:59235 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755159AbaIRV5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:57:09 -0400
Message-ID: <1411077427.2012.6.camel@x41>
Subject: Re: [PATCH] ASoC: samsung: Remove goni or aquila with the WM8994
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@kernel.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Sep 2014 23:57:07 +0200
In-Reply-To: <20140918175752.GC7960@sirena.org.uk>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	 <53C675E4.4020502@samsung.com> <1409825105.5546.91.camel@x220>
	 <201409041802.36466.arnd@arndb.de> <1411033409.2017.15.camel@x220>
	 <20140918175752.GC7960@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2014 21:57:07.0873 (UTC) FILETIME=[7DA23110:01CFD38B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Mark Brown schreef op do 18-09-2014 om 10:57 [-0700]:
> On Thu, Sep 18, 2014 at 11:43:29AM +0200, Paul Bolle wrote:
> > On Thu, 2014-09-04 at 18:02 +0200, Arnd Bergmann wrote:
> 
> > > I think it would be nice if you could submit a patch to remove the
> > > drivers from ASoC, then we can see if anybody complains.
> 
> > Same thing for v3.17-rc5 and next-20140918. Let's see if we can remove
> > the goni or aquila with wm8994 driver.
> > 
> > Done on top of next-20140918. Untested.
> > --------->8---------
> > From: Paul Bolle <pebolle@tiscali.nl>
> 
> Please follow the patch submission process in SubmittingPatches.

Could you please be more specific? What part of SubmittingPatches have I
skipped?

Is it the perhaps the use of scissors? Or the superfluous From: line?
"git am -c" appears to handle this message (and the very similar message
I also sent today) just fine.

Thanks,


Paul Bolle

