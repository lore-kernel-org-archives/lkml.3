Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaLaNyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:54:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47018 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbaLaNyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:54:52 -0500
Date: Wed, 31 Dec 2014 14:54:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: iwlwifi-driver card doesn't work with 3.19-rc2+
Message-ID: <20141231135448.GA6332@pd.tnic>
References: <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>
 <54A2B807.1020202@hurleysoftware.com>
 <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com>
 <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz>
 <1419971304.30412.0.camel@egrumbacBox>
 <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz>
 <20141230212326.GA29263@pd.tnic>
 <54A328C2.5080606@lwfinger.net>
 <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz>
 <0BA3FCBA62E2DC44AF3030971E174FB31B5DD429@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5DD429@hasmsx107.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 07:50:19AM +0000, Grumbach, Emmanuel wrote:
> Now - basically all your argument is on Johannes's comment:
> "deprecated enough". I think we have a chicken and egg problem here.
> We can't break things towards userland. Good. But we do want to
> deprecate this API because lots of valid purely technical reasons.
> Unfortunately, I don't see what we could do to send a strong signal to
> userspace tools developers to have them work / plan a move to a modern
> API.

I don't see what all the fuss is all about. If you're still unsure, go
read Linus' message once more. You're absolutely not allowed to break
userspace. Fullstop. No ifs and buts and whatever.

Everything extra you wanna do is probably fine. You can go talk to
userspace tools maintainers using the deprecated API, you can go and fix
it yourself, and so on and so on...

And giving Jiri hard time for "bypassing" maintainers for something
which is clearly a no-no and has to be reverted the moment it hits
mainline shows yet again you haven't really understood the rule yet:

There is no breaking of userspace. Fullstop.

Things like that get reverted ASAP. No "it needs to go through my tree",
"I'm not sure, blabalba" ...

So instead of giving him hard time, say "thank you for sending the
revert and thank you for helping us maintainers". Now, before you say
something, remember this: there is no breaking of userspace!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
