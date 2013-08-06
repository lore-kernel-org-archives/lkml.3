Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3HFP6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:58:30 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61889 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3HFP61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:58:27 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUW6P9Z_7z+o+z=qBWSFzyU8tgtY0ou+rmLcEzWbn94OXA@mail.gmail.com>
References: <CA+icZUX8OcTSOABO6Nbz5R6_5-m39rsYOpDqYBA7hf8LFvJLLA@mail.gmail.com>
	<1375797260.8219.21.camel@jlt4.sipsolutions.net>
	<CA+icZUUAJ25QybqHvxz7eubSLH6YuNjcc5zyU2O5Xi9vevMGkw@mail.gmail.com>
	<1375800617.8219.23.camel@jlt4.sipsolutions.net>
	<CA+icZUVbKpyuke6PRg3-60gOggsTb=3cNRz3Sy0RmvcZSuPaNw@mail.gmail.com>
	<1375801059.8219.24.camel@jlt4.sipsolutions.net>
	<CA+icZUXrRsXfeW9hqxTMkKW4TdNSBH-zE8-zX2Rd7HTAx5MvqQ@mail.gmail.com>
	<CA+icZUWijPJmNoqE22Msqcn7tRot3SB3e=KujMM7JNd-Om-oOw@mail.gmail.com>
	<1375802297.8219.25.camel@jlt4.sipsolutions.net>
	<CA+icZUVCFOS6SHonEqzaJyWCGCU4nqqGjBN0VbmV-=OoM+deZg@mail.gmail.com>
	<CA+icZUVuOqdZUGy2ALAF1CehOqYdr7rtEsXhqNvDtYEns2BuRQ@mail.gmail.com>
	<1375802993.8219.26.camel@jlt4.sipsolutions.net>
	<CA+icZUW6P9Z_7z+o+z=qBWSFzyU8tgtY0ou+rmLcEzWbn94OXA@mail.gmail.com>
Date: Tue, 6 Aug 2013 17:58:25 +0200
Message-ID: <CA+icZUW7LVzg7sM3O-w5oQpeaj=CT6MS6Q7cRZ1qK0h-Z4wZuw@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 6 [ wireless | iwlwifi | mac80211 ? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 5:43 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Aug 6, 2013 at 5:29 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Tue, 2013-08-06 at 17:27 +0200, Sedat Dilek wrote:
>>> On Tue, Aug 6, 2013 at 5:20 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> > On Tue, Aug 6, 2013 at 5:18 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> >>
>>> >>
>>> >>> I have sent you a v2 of my logs (with -d and rsyslog-7.x).
>>> >>
>>> >> Hmm, that looks different? There no longer is anything about "PSK might
>>> >> be wrong", but now just disconnections by the AP, which unfortunately
>>> >> indicate no reason.
>>> >>
>>> >> When was it working last?
>>> >>
>>> >
>>> > next-20130801 was OK here.
>>> >
>>>
>>> What about these lines?
>>>
>>> Aug  6 17:03:37 fambox kernel: [  134.575120] wlan0: deauthenticated
>>> from 00:04:0e:e4:00:3d (Reason: 1)
>>> Aug  6 17:03:37 fambox wpa_supplicant[2424]: wlan0: Event DEAUTH (12) received
>>> Aug  6 17:03:37 fambox wpa_supplicant[2424]: wlan0: Deauthentication
>>> notification
>>> Aug  6 17:03:37 fambox wpa_supplicant[2424]: Deauthentication frame
>>> IE(s) - hexdump(len=0): [NULL]
>>> Aug  6 17:03:37 fambox wpa_supplicant[2424]: wlan0: WPA: 4-Way
>>> Handshake failed - pre-shared key may be incorrect
>>> Aug  6 17:03:37 fambox NetworkManager[2431]: <info> (wlan0):
>>> supplicant interface state: 4-way handshake -> disconnected
>>
>> Yeah but before you had a local deauth request, this time it's the AP
>> kicking you off.
>>
>> I really don't know. Can you try something like wireless-testing maybe?
>> -next could have any kind of breakage I guess ...
>>
>
> I pulled in master-2013-08-05 tag on top of Linux v3.11-rc4... Building...
>

$ cat /proc/version
Linux version 3.11.0-rc4-1-wl-20130805 (sedat.dilek@gmail.com@fambox)
(gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #1 SMP Tue Aug 6
17:52:45 CEST 2013

This kernel boots fine and has no WiFi problems.

> You assume a breakage in a different area than wireless or network in general?
>

Any wild guess?

- Sedat -
