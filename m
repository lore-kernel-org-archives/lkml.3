Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3CUTRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:17:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53202 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752423Ab3CUTQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:16:45 -0400
Message-ID: <1363893405.30275.39.camel@joe-AO722>
Subject: Re: [PATCH] sound: max98090: Remove executable bit
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 12:16:45 -0700
In-Reply-To: <20130321184458.GH15926@opensource.wolfsonmicro.com>
References: <1363730323.16270.11.camel@joe-AO722>
	 <20130320095758.GD28775@opensource.wolfsonmicro.com>
	 <1363792936.16270.30.camel@joe-AO722>
	 <20130320163627.GS28775@opensource.wolfsonmicro.com>
	 <1363820072.16270.43.camel@joe-AO722>
	 <20130321162503.GC14768@opensource.wolfsonmicro.com>
	 <1363886175.30275.10.camel@joe-AO722>
	 <20130321174440.GG15926@opensource.wolfsonmicro.com>
	 <1363888393.30275.31.camel@joe-AO722>
	 <20130321184458.GH15926@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 19:44 +0100, Mark Brown wrote:
> On Thu, Mar 21, 2013 at 10:53:13AM -0700, Joe Perches wrote:
> > On Thu, 2013-03-21 at 18:44 +0100, Mark Brown wrote:
> 
> > > That one needs a bit more taste and thought to work out what's
> > > appropraite than can be guaranteed easily with a script, things like
> > > working out drive level prefixes for example.
> 
> > [perfectly useful git applypatch-msg hook script removed]
> 
> No, it really isn't.  Have you tried looking at the output?  It's not
> going to do the right thing for the subject line here for example, never
> mind any other cases.

Define "the right thing" for this instance.

The commit isn't in -next so I have no idea what
you actually applied. (nor do I really care btw)

Did you try it?

It commits:

ASoC: sound: max98080: Remove executable bit

If you're really anal about it and you want
sound: for sound/soc removed,

perl -p -i -e 's/^(?:ASoC:\s*)?(?:sound:\s*)?(.*)$/ASoC: $1/g if 1 .. 1' ${1+"$@"}

This is a "your taste" issue only, and do keep in mind
mountains vs molehills.

cheers, Joe

