Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab3EOMIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:08:06 -0400
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:38971 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3EOMIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:08:04 -0400
Date: Wed, 15 May 2013 21:08:01 +0900
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Causey <matt.causey@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        hostap@lists.shmoo.com
Subject: Re: RTL driver for RTL8191SEvB and/or wpa-supplicant really broken
	at times
Message-ID: <20130515120801.GA24670@gamma.logic.tuwien.ac.at>
References: <20130509115630.GC5111@gamma.logic.tuwien.ac.at> <CAGnc4p8w-Y8QHsEM_SbQLxFSfHC_X1ZCQpeKCXFJ8Qtk-cLHrA@mail.gmail.com> <20130509115630.GC5111@gamma.logic.tuwien.ac.at> <518BC290.2040306@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnc4p8w-Y8QHsEM_SbQLxFSfHC_X1ZCQpeKCXFJ8Qtk-cLHrA@mail.gmail.com> <518BC290.2040306@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

sorry for the late reply, business trip to Tokyo.

On Do, 09 Mai 2013, Larry Finger wrote:
> absolutely critical, namely the PCI ID. There are at least three 

10ec:8172

> I also recommend that you try either the wireless-testing git repo or the 
> mainline git repo. There are a lot of changes that cannot be backported.

Ok, I will try.

On Fr, 10 Mai 2013, Matt Causey wrote:
> Seems to indicate that the access point is ignoring your probe requests.
> If that is happening for your client somehow, wpa_supplicant won't work
> well.  :-)

I rebooted the rooter, after that it worked, for one day. After that
agian problems.

Then I rebooted also linux and it works again.

> "NecAcces" - but I'm not familiar with that vendor.  Also, do you have a

Aterm WR8600N http://121ware.com/aterm/
which is a NEC part, probably sold in other places under a different
name. In Japan it is sold as this.

> WLAN packet capture (from another host nearby on the same channel)?  That
> would be helpful as well.

Difficult, I only have an iPhone, and a wireless repeater for the TV,
and I guess both are not enough for wlan sniffing.

In the meantime I have also tried wpa_supplicatn 2.0, without
chagnes.

In the current log there are strange things:
May 15 20:36:38 tofuschnitzel kernel: [78541.678861] wlan0: send auth to 00:3a
:9d:b4:54:5a (try 1/3)
May 15 20:36:38 tofuschnitzel NetworkManager[16128]: <info> (wlan0): supplican
t interface state: scanning -> authenticating
May 15 20:36:38 tofuschnitzel kernel: [78541.681046] wlan0: authenticated
May 15 20:36:43 tofuschnitzel kernel: [78546.680713] wlan0: deauthenticating from 00:3a:9d:b4:54:5a by local choice (reason=3)
May 15 20:36:43 tofuschnitzel NetworkManager[16128]: <info> (wlan0): supplicant interface state: authenticating -> disconnected
May 15 20:36:44 tofuschnitzel NetworkManager[16128]: <info> (wlan0): supplicant interface state: disconnected -> scanning

Why does it go from authenticated -> directly to deauthenticating. Uffa.

Anyway, I will try some more things, esp wireless-testing.

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
