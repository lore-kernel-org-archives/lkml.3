Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab3HFP37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:29:59 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:55572 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab3HFP36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:29:58 -0400
Message-ID: <1375802993.8219.26.camel@jlt4.sipsolutions.net>
Subject: Re: linux-next: Tree for Aug 6 [ wireless | iwlwifi | mac80211 ? ]
From: Johannes Berg <johannes@sipsolutions.net>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wireless <linux-wireless@vger.kernel.org>
Date: Tue, 06 Aug 2013 17:29:53 +0200
In-Reply-To: <CA+icZUVuOqdZUGy2ALAF1CehOqYdr7rtEsXhqNvDtYEns2BuRQ@mail.gmail.com> (sfid-20130806_172725_033196_729FC01D)
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
	 (sfid-20130806_172725_033196_729FC01D)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 17:27 +0200, Sedat Dilek wrote:
> On Tue, Aug 6, 2013 at 5:20 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > On Tue, Aug 6, 2013 at 5:18 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >>
> >>
> >>> I have sent you a v2 of my logs (with -d and rsyslog-7.x).
> >>
> >> Hmm, that looks different? There no longer is anything about "PSK might
> >> be wrong", but now just disconnections by the AP, which unfortunately
> >> indicate no reason.
> >>
> >> When was it working last?
> >>
> >
> > next-20130801 was OK here.
> >
> 
> What about these lines?
> 
> Aug  6 17:03:37 fambox kernel: [  134.575120] wlan0: deauthenticated
> from 00:04:0e:e4:00:3d (Reason: 1)
> Aug  6 17:03:37 fambox wpa_supplicant[2424]: wlan0: Event DEAUTH (12) received
> Aug  6 17:03:37 fambox wpa_supplicant[2424]: wlan0: Deauthentication
> notification
> Aug  6 17:03:37 fambox wpa_supplicant[2424]: Deauthentication frame
> IE(s) - hexdump(len=0): [NULL]
> Aug  6 17:03:37 fambox wpa_supplicant[2424]: wlan0: WPA: 4-Way
> Handshake failed - pre-shared key may be incorrect
> Aug  6 17:03:37 fambox NetworkManager[2431]: <info> (wlan0):
> supplicant interface state: 4-way handshake -> disconnected

Yeah but before you had a local deauth request, this time it's the AP
kicking you off.

I really don't know. Can you try something like wireless-testing maybe?
-next could have any kind of breakage I guess ...

johannes

