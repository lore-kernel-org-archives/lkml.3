Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3HFO5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:57:46 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:55482 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab3HFO5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:57:45 -0400
Message-ID: <1375801059.8219.24.camel@jlt4.sipsolutions.net>
Subject: Re: linux-next: Tree for Aug 6 [ wireless | iwlwifi | mac80211 ? ]
From: Johannes Berg <johannes@sipsolutions.net>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wireless <linux-wireless@vger.kernel.org>
Date: Tue, 06 Aug 2013 16:57:39 +0200
In-Reply-To: <CA+icZUVbKpyuke6PRg3-60gOggsTb=3cNRz3Sy0RmvcZSuPaNw@mail.gmail.com> (sfid-20130806_165609_226807_76ACA1EA)
References: <CA+icZUX8OcTSOABO6Nbz5R6_5-m39rsYOpDqYBA7hf8LFvJLLA@mail.gmail.com>
	 <1375797260.8219.21.camel@jlt4.sipsolutions.net>
	 <CA+icZUUAJ25QybqHvxz7eubSLH6YuNjcc5zyU2O5Xi9vevMGkw@mail.gmail.com>
	 <1375800617.8219.23.camel@jlt4.sipsolutions.net>
	 <CA+icZUVbKpyuke6PRg3-60gOggsTb=3cNRz3Sy0RmvcZSuPaNw@mail.gmail.com>
	 (sfid-20130806_165609_226807_76ACA1EA)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 16:56 +0200, Sedat Dilek wrote:
> On Tue, Aug 6, 2013 at 4:50 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2013-08-06 at 16:46 +0200, Sedat Dilek wrote:
> >
> > Heh, the interesting messages are always cut out of the log:
> >
> > Aug  6 16:30:34 fambox wpa_supplicant[2533]: wlan0: WPA: RX message 1 of 4-Way Handshake from 00:04:0e:e4:00:3d (ver=2)
> > Aug  6 16:30:34 fambox wpa_supplicant[2533]: RSN: msg 1/4 key data - hexdump(len=0):
> > Aug  6 16:30:34 fambox wpa_supplicant[2533]: Get randomness: len=32 entropy=4
> > Aug  6 16:30:34 fambox wpa_supplicant[2533]: random from os_get_random - hexdump(len=32): [REMOVED]
> > Aug  6 16:30:34 fambox wpa_supplicant[2533]: random_mix_pool - hexdump(len=20): [REMOVED]
> > Aug  6 16:30:34 fambox wpa_supplicant[2533]: random from internal pool - hexdump(len=16): [REMOVED]
> > Aug  6 16:30:34 fambox wpa_supplicant[2533]: random_mix_pool - hexdump(len=20): [REMOVED]
> > Aug  6 16:30:34 fambox rsyslogd-2177: imuxsock begins to drop messages from pid 2533 due to rate-limiting
> > [...]
> >
> 
> Do you know how I can workaround the rsyslogd rate-limiting?

Me? no.

johannes

