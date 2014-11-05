Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaKEIC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:02:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbaKEICy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:02:54 -0500
Date: Wed, 5 Nov 2014 09:02:52 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v1 10/11] backports: prefix c-file / h-file auto
	backport with BPAUTO
Message-ID: <20141105080252.GK12953@wotan.suse.de>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com> <1415090582-14129-11-git-send-email-mcgrof@do-not-panic.com> <1415096092.2064.13.camel@sipsolutions.net> <20141104215002.GF12953@wotan.suse.de> <1415137850.2064.23.camel@sipsolutions.net> <20141105002147.GJ12953@wotan.suse.de> <1415172590.2589.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415172590.2589.1.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 08:29:50AM +0100, Johannes Berg wrote:
> On Wed, 2014-11-05 at 01:21 +0100, Luis R. Rodriguez wrote:
> 
> > > > I did at one point have BACKPORT_BPAUTO_* stuff on the compat/Kconfig for
> > > > the auto stuff but figured that was superfluous. I'll respin with it.
> > > 
> > > Not sure what you mean? It seems to me you should just drop the changes
> > > like the one I quoted above.
> > 
> > If we keep BACKPORT_BPAUTO as prefix on compat/Kconfig for auto backport
> > stuff we'll end up with BACKPORT_BACKPORT_BPAUTO, while technically correct
> > as you have pointed out, I find it personally superfluous. If we however
> > only use BPAUTO_ prefix on the compat/Kconfig we'll end up with BACKPORT_BPAUTO.
> 
> Correct.
> 
> > Its subjective then, but I was opting in to prefer to just keep BPAUTO_ prefix
> > with the resulting CPTCFG_BPAUTO for packaging and CONFIG_BACKPORT_BPAUTO for
> > integration for these, if you however feel its best to double the BACKPORT
> > prefix that's fine too, it just seemed odd (although I realize correct).
> 
> No, I'm perfectly happy with CPTCFG_BPAUTO.

OK cool.

> But the *code* changes
> you're making here that check whether bp_prefix is being duplicated
> aren't necessary for that, and are in fact confusing and dangerous.

Understood, thanks for the review, hopefully this is addressed with the
latest series.

  Luis
