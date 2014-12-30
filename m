Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaL3Wmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:42:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbaL3Wmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:42:51 -0500
Date: Tue, 30 Dec 2014 23:42:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Borislav Petkov <bp@alien8.de>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi-driver card doesn't work with 3.19-rc2+
In-Reply-To: <54A328C2.5080606@lwfinger.net>
Message-ID: <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz>
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz> <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com> <54A2B807.1020202@hurleysoftware.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com>
 <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz> <1419971304.30412.0.camel@egrumbacBox> <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz> <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2014, Larry Finger wrote:

> > > If wireless maintainers think otherwise, I'll send a revert request to
> > > Linus for consideration.
> > 
> > I wonder if the reaction would be like this one:
> > 
> > https://lkml.org/lkml/2012/12/23/75
> > 
> > :-)
> 
> It would be a little like that.
> 
> One thread of interest is https://lkml.org/lkml/2014/12/22/348. Commit
> 24a0aa212ee2 ("cfg80211: make WEXT compatibility unselectable") made it
> impossible to select the IPW2200. The patch to allow selecting the IPW2200,
> which automatically selects CFG80211_WEXT has been added to wireless-drivers,
> but it has not yet made it to mainline. Once it does, then choosing to build
> the IPW2200 will provide a workaround.
> 
> In my opinion, the need for the IPW2200 to have CFG80211_WEXT means that the
> original commit will likely be reverted, but your voice will help.

Ok, thanks a lot for another datapoint. I am sending revert patch to Linus 
tonight.

-- 
Jiri Kosina
SUSE Labs
