Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab3CURxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:53:16 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42698 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751561Ab3CURxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:53:13 -0400
Message-ID: <1363888393.30275.31.camel@joe-AO722>
Subject: Re: [PATCH] sound: max98090: Remove executable bit
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 10:53:13 -0700
In-Reply-To: <20130321174440.GG15926@opensource.wolfsonmicro.com>
References: <1363730323.16270.11.camel@joe-AO722>
	 <20130320095758.GD28775@opensource.wolfsonmicro.com>
	 <1363792936.16270.30.camel@joe-AO722>
	 <20130320163627.GS28775@opensource.wolfsonmicro.com>
	 <1363820072.16270.43.camel@joe-AO722>
	 <20130321162503.GC14768@opensource.wolfsonmicro.com>
	 <1363886175.30275.10.camel@joe-AO722>
	 <20130321174440.GG15926@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 18:44 +0100, Mark Brown wrote:
> On Thu, Mar 21, 2013 at 10:16:15AM -0700, Joe Perches wrote:
> > On Thu, 2013-03-21 at 17:25 +0100, Mark Brown wrote:
> 
> > > I don't think you're quite understanding the issues with automation
> > > here.  Or indeed the desired end result.
> 
> > What issue is that?
> 
> That one needs a bit more taste and thought to work out what's
> appropraite than can be guaranteed easily with a script, things like
> working out drive level prefixes for example.

[perfectly useful git applypatch-msg hook script removed]

> No, that's going to leave essentially every commit that needs fixing up
> still needing manual fixup.

Then I'm sure that's your job as a maintainer
to modify whatever patches you get to suit your
taste.

I think what I did is perfectly tasty.

ttfn, o+o, ttyl, tafn, etc...

