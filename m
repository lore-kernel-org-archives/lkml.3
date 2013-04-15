Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab3DOQeC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:34:02 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:50090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab3DOQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:34:00 -0400
Message-ID: <1366043632.8361.33.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 5/7] backports: add support for voltage / current
 regulator drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Mark Brown <broonie@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 15 Apr 2013 18:33:52 +0200
In-Reply-To: <20130415162652.GK15837@opensource.wolfsonmicro.com>
References: <1365862424-6530-1-git-send-email-mcgrof@do-not-panic.com>
	 <1365862424-6530-6-git-send-email-mcgrof@do-not-panic.com>
	 <1365886878.1089.5.camel@jlt4.sipsolutions.net>
	 <20130415162652.GK15837@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 17:26 +0100, Mark Brown wrote:
> On Sat, Apr 13, 2013 at 11:01:18PM +0200, Johannes Berg wrote:
> > On Sat, 2013-04-13 at 07:13 -0700, Luis R. Rodriguez wrote:
> 
> > > This backports the latest regulator drivers for kernels >= 3.4.
> > > We enable the regulator only on kernels >= 3.4 given that
> > > it relies on the new probe deferral mechanism which would
> > > otherwise mean having to support drivers that do not probe
> > > correctly. Note that 3.2 had a base regulator implementation
> > > but that was just stubs.
> 
> > Applied.
> 
> Please let's at least discuss the issues here, I'm not sure what this is
> supposed to do but the analysis of the subsystem didn't seem complete.

I wouldn't worry about it too much. For some reason (media drivers
related?) Luis decided that it was worth including this in the backports
project (see http://backports.wiki.kernel.org) and I am currently
maintaining the git tree for that, at least while I was doing some
refactoring.

I do notice that it doesn't quite work, there are a lot of unresolved
symbols :)

If you think you'd be impacted by this because users demand support from
you for the backport or whatever I can revert this (or probably just
remove it from the copy list for now.) I don't really have an opinion on
it, I'm doing this because I'm interested in one specific wireless
driver.

johannes

