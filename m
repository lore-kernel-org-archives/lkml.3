Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaLaWlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 17:41:09 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:23263 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaLaWlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 17:41:07 -0500
X-IronPort-AV: E=Sophos;i="5.07,675,1413270000"; 
   d="scan'208";a="54153071"
Message-ID: <54A47B7F.9000403@broadcom.com>
Date: Wed, 31 Dec 2014 23:41:03 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, Jiri Kosina <jkosina@suse.cz>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
References: <54A328C2.5080606@lwfinger.net>	<alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz>	<alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz>	<54A3D955.6020809@broadcom.com>	<0BA3FCBA62E2DC44AF3030971E174FB31B5DD72E@hasmsx107.ger.corp.intel.com>	<54A3E1F1.7030807@broadcom.com>	<alpine.LNX.2.00.1412311505100.31609@pobox.suse.cz>	<54A41000.3040306@broadcom.com>	<20141231173113.GA443@thunk.org>	<54A45D4D.7070302@broadcom.com>	<20141231214421.GA29273@thunk.org> <CA+55aFzp2bWctqpiHyZVC9ZCtW3wN_bPsGjcbqKFgu9KOZtAJw@mail.gmail.com>
In-Reply-To: <CA+55aFzp2bWctqpiHyZVC9ZCtW3wN_bPsGjcbqKFgu9KOZtAJw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/14 22:57, Linus Torvalds wrote:
> On Wed, Dec 31, 2014 at 1:44 PM, Theodore Ts'o<tytso@mit.edu>  wrote:
>>
>> Yeah, the confusing part is that "ip" tends to use "verb object"
>> scheme, which is consistent with the Cisco IOS command set it was
>> trying to emulate.
>
> Side note: does anybody think that was really a good idea to begin
> with? I mean, Cisco iOS is just _soooo_ universally loved, right?

I think I sense a bit cynical (under)tone here ;-)

> And yeah, I refuse to use "ip link" or other insane commands. Let's
> face it, "ifconfig" and "route" are perfectly fine commands, and a
> whole lot less confusing than "ip" with random crap after it.  I'm
> really not seeing why that "ip" command was seen as an improvement.

So does "ip" provide the same functionality as "ifconfig" and "route" or 
does the package have more to offer.

The "iw" tool provides much more subcommands to perform different 
wireless tasks that are not provided by "iwconfig" and friends. So 
functionally "iw" provides a superset. Just have to get equivalent 
output format to mimic "iwconfig" as Ted suggested.

Well, that's something for next year as we are getting close to midnight 
over here.

Regards,
Arend

> (Ok, "ip route" isn't any more complex than "route", but "ip link"
> sure as hell isn't simpler than "ifconfig" for most things I can think
> of)
>
>                       Linus

