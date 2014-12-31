Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaLaNtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:49:11 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:50896 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaLaNtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:49:09 -0500
Message-ID: <54A3FECC.7050202@hurleysoftware.com>
Date: Wed, 31 Dec 2014 08:49:00 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Arend van Spriel <arend@broadcom.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz> <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com> <54A2B807.1020202@hurleysoftware.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com> <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz> <1419971304.30412.0.camel@egrumbacBox> <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz> <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net> <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz> <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz> <54A3D955.6020809@broadcom.com> <alpine.LNX.2.00.1412311408090.31609@pobox.suse.cz> <0BA3FCBA62E2DC44AF3030971E174FB31B5DD8D8@hasmsx107.ger.corp.intel.com>
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5DD8D8@hasmsx107.ger.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2014 08:26 AM, Grumbach, Emmanuel wrote:
>>
>> On Wed, 31 Dec 2014, Arend van Spriel wrote:
>>
>>> You mentioned in the discussion and I quote: "*If* wireless
>>> maintainers think otherwise, I'll send a revert request to Linus for
>>> consideration.". However, you did not wait for any response from the
>>> wireless maintainers nor from the author of the patch you are reverting.
>>> Seems like an overreaction to me though personally I do not disgree
>>> with the revert itself.
>>
>> My understanding from the whole thread was that Emmanuel disagrees with
>> the revert, and I consider Emmanuel to definitely belong to the "wireless
>> maintainers" group. If my understanding was wrong on this, sorry for that.
> 
> You understanding is wrong. This patch has an author and you could I didn't
> sign-off the patch which is an obvious indication I am not a "wireless maintainer".
> You didn't even make the minimal effort to check how this patch should be properly
> routed.
> 
> Regardless of all this, I didn't say I disagree, I said that we need to find a way to signal
> the userland developers that an API will be deprecated at some point. I haven't seen
> any response / suggestion from you on that.

pr_notice_once("WEXT compatibility has been deprecated since _____" \
               " Upgrade your userspace tools to nl80211!\n");

