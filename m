Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaKEIUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:20:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaKEIUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:20:31 -0500
Date: Wed, 5 Nov 2014 09:20:29 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v1 10/11] backports: prefix c-file / h-file auto
	backport with BPAUTO
Message-ID: <20141105082029.GL12953@wotan.suse.de>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com> <1415090582-14129-11-git-send-email-mcgrof@do-not-panic.com> <1415096092.2064.13.camel@sipsolutions.net> <20141104215002.GF12953@wotan.suse.de> <1415137850.2064.23.camel@sipsolutions.net> <20141105002147.GJ12953@wotan.suse.de> <1415172590.2589.1.camel@sipsolutions.net> <20141105080252.GK12953@wotan.suse.de> <1415175123.2589.10.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415175123.2589.10.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 09:12:03AM +0100, Johannes Berg wrote:
> On Wed, 2014-11-05 at 09:02 +0100, Luis R. Rodriguez wrote:
> 
> > > But the *code* changes
> > > you're making here that check whether bp_prefix is being duplicated
> > > aren't necessary for that, and are in fact confusing and dangerous.
> > 
> > Understood, thanks for the review, hopefully this is addressed with the
> > latest series.
> 
> Actually, maybe you wanted these changes because you didn't want to end
> up with CONFIG_BACKPORT_BPAUTO_ for integration? I think that's a small
> price to pay though for code complexity trade-off, IMHO you should
> accept CONFIG_BACKPORT_BPAUTO_ and remove the code changes.

Quite the contrary, I did this to get CONFIG_BACKPORT_BPAUTO_ and not
CONFIG_BACKPORT_BACKPORT_. So right now I do get CONFIG_BACKPORT_BPAUTO_
for integration (with the v2 patch series).

  Luis
