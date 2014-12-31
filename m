Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaLaPDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:03:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaLaPDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:03:36 -0500
Date: Wed, 31 Dec 2014 16:03:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Julian Calaby <julian.calaby@gmail.com>
cc: Borislav Petkov <bp@alien8.de>, Peter Hurley <peter@hurleysoftware.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Arend van Spriel <arend@broadcom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility
 unselectable"
In-Reply-To: <CAGRGNgWcoEf87ndwTpm7zc6vdJ3PWNOSP9CBca40iSrZ4+e17g@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1412311602030.31609@pobox.suse.cz>
References: <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz> <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net> <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz> <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz> <54A3D955.6020809@broadcom.com>
 <alpine.LNX.2.00.1412311408090.31609@pobox.suse.cz> <0BA3FCBA62E2DC44AF3030971E174FB31B5DD8D8@hasmsx107.ger.corp.intel.com> <54A3FECC.7050202@hurleysoftware.com> <CAGRGNgVMa=P9XbuFqfKHu5Gpiw=3h_OtOzSUYCsMbVLfTuL2Zw@mail.gmail.com> <20141231144617.GE6332@pd.tnic>
 <CAGRGNgWcoEf87ndwTpm7zc6vdJ3PWNOSP9CBca40iSrZ4+e17g@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jan 2015, Julian Calaby wrote:

> The point is that WEXT has been depreciated for _years_. Nobody seems
> to have listened. Yes, talking to maintainers will get the last
> holdouts of the "big" tools (e.g. wicd) to fix them, but it's not
> going to change all the people out there with hacked together
> home-grown setups.

Exactly. So why not work with whoever maintains iwconfig and friends, so 
that they are turned into functionally equivalent wrappers around iw? Only 
then it seems to make sense to start any kind of depreciation.

-- 
Jiri Kosina
SUSE Labs
