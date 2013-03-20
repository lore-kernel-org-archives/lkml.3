Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3CTWyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:54:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60241 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753799Ab3CTWyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:54:33 -0400
Message-ID: <1363820072.16270.43.camel@joe-AO722>
Subject: Re: [PATCH] sound: max98090: Remove executable bit
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 15:54:32 -0700
In-Reply-To: <20130320163627.GS28775@opensource.wolfsonmicro.com>
References: <1363730323.16270.11.camel@joe-AO722>
	 <20130320095758.GD28775@opensource.wolfsonmicro.com>
	 <1363792936.16270.30.camel@joe-AO722>
	 <20130320163627.GS28775@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 17:36 +0100, Mark Brown wrote:
> On Wed, Mar 20, 2013 at 08:22:16AM -0700, Joe Perches wrote:
> > On Wed, 2013-03-20 at 10:57 +0100, Mark Brown wrote:
> 
> > > I've applied this but I'm fed up to the back teeth of having to hand
> > > edit trivial patches from you because you ignore the subject line styles
> > > of subsystems and make up your own.
> 
> > Your style rules just don't matter to me and
> > you can ignore the patches and fix it yourself.
> 
> > Or better, create a tool for others to use that
> > follow your silly style rules.
> 
> This is just like any other coding style thing - you should be creating
> patches that look like other patches for the affected, if there's things
> like obvious visual differences in what you're doing you're doing it
> wrong.

We've had this conversation before and I proposed
to you a simple solution.
https://lkml.org/lkml/2010/11/16/245
and I still more or less agree with Florian
https://lkml.org/lkml/2010/11/16/314

I'm not doing it wrong.  You have another demand
others don't.  I simply don't find it necessary to
cater to you.

If you want it to be agreed that there is a specific
form for subject headers that varies by maintainer tree,
change SubmittingPatches Paragraph 11.

> Automation doesn't work for things like this, there's a good solid
> reason why there's generally a human involved in patch; the other people
> who submit lots of cleanups generally manage to figure this out
> usefully, you might want to discuss techniques with them.

I suggest you use a git pre-commit hook to your
tree and use sed/perl to add a specific prefix
if it doesn't exist.
http://codeinthehole.com/writing/tips-for-using-a-git-pre-commit-hook/


