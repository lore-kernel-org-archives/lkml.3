Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaLaPFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:05:32 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33069 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaLaPFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:05:30 -0500
MIME-Version: 1.0
In-Reply-To: <20141231144617.GE6332@pd.tnic>
References: <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz>
 <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net>
 <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz> <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz>
 <54A3D955.6020809@broadcom.com> <alpine.LNX.2.00.1412311408090.31609@pobox.suse.cz>
 <0BA3FCBA62E2DC44AF3030971E174FB31B5DD8D8@hasmsx107.ger.corp.intel.com>
 <54A3FECC.7050202@hurleysoftware.com> <CAGRGNgVMa=P9XbuFqfKHu5Gpiw=3h_OtOzSUYCsMbVLfTuL2Zw@mail.gmail.com>
 <20141231144617.GE6332@pd.tnic>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 1 Jan 2015 01:56:54 +1100
Message-ID: <CAGRGNgWcoEf87ndwTpm7zc6vdJ3PWNOSP9CBca40iSrZ4+e17g@mail.gmail.com>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
To: Borislav Petkov <bp@alien8.de>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Thu, Jan 1, 2015 at 1:46 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jan 01, 2015 at 01:40:53AM +1100, Julian Calaby wrote:
>> Sadly, nobody will read that. It needs to be at least an error,
>> possibly with a big splat to scare people.
>>
>> Maybe using one of WARN()'s siblings instead.
>
> And that opens a lot of useless bugzillas...
>
> The right thing to do is go talk to the maintainers of the userspace
> tools or send patches.

The point is that WEXT has been depreciated for _years_. Nobody seems
to have listened. Yes, talking to maintainers will get the last
holdouts of the "big" tools (e.g. wicd) to fix them, but it's not
going to change all the people out there with hacked together
home-grown setups.

Yes, a full WARN() will end up with loads of duplicated bugzillas -
and I wish I had the time to volunteer to close every last one with
"upgrade your userspace to use nl80211 / iw" - but I feel that
speaking quietly hasn't worked: maybe now we need to yell.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
