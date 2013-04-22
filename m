Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3DVNLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:11:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41482 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab3DVNLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:11:06 -0400
Date: Mon, 22 Apr 2013 14:11:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] backports: add support for voltage / current
 regulator drivers
Message-ID: <20130422131101.GA17463@sirena.org.uk>
Mail-Followup-To: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	backports@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
	linux-kernel@vger.kernel.org
References: <1365862424-6530-1-git-send-email-mcgrof@do-not-panic.com>
 <1365862424-6530-6-git-send-email-mcgrof@do-not-panic.com>
 <1365886878.1089.5.camel@jlt4.sipsolutions.net>
 <20130415162652.GK15837@opensource.wolfsonmicro.com>
 <1366043632.8361.33.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366043632.8361.33.camel@jlt4.sipsolutions.net>
X-Cookie: No campfires allowed.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 06:33:52PM +0200, Johannes Berg wrote:
> On Mon, 2013-04-15 at 17:26 +0100, Mark Brown wrote:

> > Please let's at least discuss the issues here, I'm not sure what this is
> > supposed to do but the analysis of the subsystem didn't seem complete.

> I wouldn't worry about it too much. For some reason (media drivers
> related?) Luis decided that it was worth including this in the backports
> project (see http://backports.wiki.kernel.org) and I am currently
> maintaining the git tree for that, at least while I was doing some
> refactoring.

> I do notice that it doesn't quite work, there are a lot of unresolved
> symbols :)

> If you think you'd be impacted by this because users demand support from
> you for the backport or whatever I can revert this (or probably just
> remove it from the copy list for now.) I don't really have an opinion on
> it, I'm doing this because I'm interested in one specific wireless
> driver.

Well, I'd much rather have a sane backport if we're going to have one -
whatever problem is being solved here it seems likely that someone else
will have the same need and if there's a general kernel project for this
(which preusmably has some overlap with LTSI?) it seems bad to have one
that people have to be warned away from using.

Given how big the misunderstandings in the cover letter for Luis' patch
were I'd be really concerned about seeing this going into anything
officialish without some discussion about what's going on.
