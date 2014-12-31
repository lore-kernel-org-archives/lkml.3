Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaLaN1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:27:01 -0500
Received: from mga14.intel.com ([192.55.52.115]:21837 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaLaN07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:26:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,673,1413270000"; 
   d="scan'208";a="631210630"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Jiri Kosina <jkosina@suse.cz>, Arend van Spriel <arend@broadcom.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: RE: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
Thread-Topic: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
Thread-Index: AQHQJINHASoXmCzt7UaJrD69LgOnMJypadiAgAAh4ACAACTaYA==
Date: Wed, 31 Dec 2014 13:26:53 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B5DD8D8@hasmsx107.ger.corp.intel.com>
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz>
 <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>
 <54A2B807.1020202@hurleysoftware.com>
 <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com>
 <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz>
 <1419971304.30412.0.camel@egrumbacBox>
 <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz>
 <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net>
 <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz>
 <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz>
 <54A3D955.6020809@broadcom.com>
 <alpine.LNX.2.00.1412311408090.31609@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1412311408090.31609@pobox.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Wed, 31 Dec 2014, Arend van Spriel wrote:
> 
> > You mentioned in the discussion and I quote: "*If* wireless
> > maintainers think otherwise, I'll send a revert request to Linus for
> > consideration.". However, you did not wait for any response from the
> > wireless maintainers nor from the author of the patch you are reverting.
> > Seems like an overreaction to me though personally I do not disgree
> > with the revert itself.
> 
> My understanding from the whole thread was that Emmanuel disagrees with
> the revert, and I consider Emmanuel to definitely belong to the "wireless
> maintainers" group. If my understanding was wrong on this, sorry for that.

You understanding is wrong. This patch has an author and you could I didn't
sign-off the patch which is an obvious indication I am not a "wireless maintainer".
You didn't even make the minimal effort to check how this patch should be properly
routed.

Regardless of all this, I didn't say I disagree, I said that we need to find a way to signal
the userland developers that an API will be deprecated at some point. I haven't seen
any response / suggestion from you on that.

> 
> One way or another, the revert really is a-must-have, as it causes visible
> userspace regressions. I am really surprised that it's causing so lively
> discussion and doubts.
> 
> --
> Jiri Kosina
> SUSE Labs
