Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaLaNKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:10:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaLaNK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:10:28 -0500
Date: Wed, 31 Dec 2014 14:10:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Arend van Spriel <arend@broadcom.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility
 unselectable"
In-Reply-To: <54A3D955.6020809@broadcom.com>
Message-ID: <alpine.LNX.2.00.1412311408090.31609@pobox.suse.cz>
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz> <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com> <54A2B807.1020202@hurleysoftware.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com>
 <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz> <1419971304.30412.0.camel@egrumbacBox> <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz> <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net> <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz>
 <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz> <54A3D955.6020809@broadcom.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2014, Arend van Spriel wrote:

> You mentioned in the discussion and I quote: "*If* wireless maintainers 
> think otherwise, I'll send a revert request to Linus for 
> consideration.". However, you did not wait for any response from the 
> wireless maintainers nor from the author of the patch you are reverting. 
> Seems like an overreaction to me though personally I do not disgree with 
> the revert itself.

My understanding from the whole thread was that Emmanuel disagrees with 
the revert, and I consider Emmanuel to definitely belong to the "wireless 
maintainers" group. If my understanding was wrong on this, sorry for that.

One way or another, the revert really is a-must-have, as it causes visible 
userspace regressions. I am really surprised that it's causing so lively 
discussion and doubts.

-- 
Jiri Kosina
SUSE Labs
