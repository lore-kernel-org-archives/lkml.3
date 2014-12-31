Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaLaPLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:11:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55590 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaLaPLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:11:38 -0500
Date: Wed, 31 Dec 2014 16:11:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Arend van Spriel <arend@broadcom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
Message-ID: <20141231151135.GF6332@pd.tnic>
References: <54A328C2.5080606@lwfinger.net>
 <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz>
 <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz>
 <54A3D955.6020809@broadcom.com>
 <alpine.LNX.2.00.1412311408090.31609@pobox.suse.cz>
 <0BA3FCBA62E2DC44AF3030971E174FB31B5DD8D8@hasmsx107.ger.corp.intel.com>
 <54A3FECC.7050202@hurleysoftware.com>
 <CAGRGNgVMa=P9XbuFqfKHu5Gpiw=3h_OtOzSUYCsMbVLfTuL2Zw@mail.gmail.com>
 <20141231144617.GE6332@pd.tnic>
 <CAGRGNgWcoEf87ndwTpm7zc6vdJ3PWNOSP9CBca40iSrZ4+e17g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGRGNgWcoEf87ndwTpm7zc6vdJ3PWNOSP9CBca40iSrZ4+e17g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 01:56:54AM +1100, Julian Calaby wrote:
> The point is that WEXT has been depreciated for _years_. Nobody
> seems to have listened. Yes, talking to maintainers will get the
> last holdouts of the "big" tools (e.g. wicd) to fix them, but it's
> not going to change all the people out there with hacked together
> home-grown setups.

That's fine - you can fix the major tools first and then take a look at
the home-grown fun later.

> Yes, a full WARN() will end up with loads of duplicated bugzillas -
> and I wish I had the time to volunteer to close every last one with
> "upgrade your userspace to use nl80211 / iw" - but I feel that
> speaking quietly hasn't worked: maybe now we need to yell.

This goes to show once again how hard it is to design a userspace
interface properly and how hard it is to change it once it gets exposed.

But yeah, screaming or not screaming, you will have to support it anyway
as long as there are tools using it. This is why I think the proper and
maybe faster way to address the situation is to go fix userspace tools
instead of issuing warnings. People never look at those as long as it
works, in my experience.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
