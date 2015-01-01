Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbbAAK6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 05:58:55 -0500
Received: from mout2.freenet.de ([195.4.92.92]:41362 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbbAAK6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 05:58:50 -0500
Message-ID: <54A527CE.4000407@maya.org>
Date: Thu, 01 Jan 2015 11:56:14 +0100
From: Andreas Hartmann <andihartmann@freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Jiri Kosina <jkosina@suse.cz>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz> <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com> <54A2B807.1020202@hurleysoftware.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com> <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz> <1419971304.30412.0.camel@egrumbacBox> <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz> <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net> <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz> <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz> <54A3D955.6020809@broadcom.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DD72E@hasmsx107.ger.corp.intel.com> <54A3E1F1.7030807@broadcom.com> <alpine.LNX.2.00.1412311505100.31609@pobox.suse.cz> <54A412CE.6010803@maya.org> <54A45309.6080606@broadcom.com>
In-Reply-To: <54A45309.6080606@broadcom.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originated-At: 79.222.43.200!53136
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arend van Spriel wrote:
> On 12/31/14 16:14, Andreas Hartmann wrote:
[...]
>> All in all:
>> If you want to get rid of wext, you still have to go a *very* long way
>> to get the same *stable* and high throughput quality with *all* chips
>> depending on mac80211 and not just a few flagship drivers like Atheros.
> 
> Hi Andreas,
> 
> That's a nice list of unrelated stuff. This has all nothing to do with
> WEXT. Actually, you can build rt5572sta with cfg80211 support
> (RT_CFG80211_SUPPORT).

You seem to know sources I don't know off. Could you please tell me,
where to find them?

I have DPO_RT5572_LinuxSTA_2.6.0.1_20120629 which doesn't compile with
HAS_CFG80211_SUPPORT=y because -DCONFIG_AP_SUPPORT, on which
RT_CFG80211_SUPPORT relies, is broken.

DPO_RT5572_LinuxSTA_2.6.1.3_20121022 removed the necessary broken AP
code completely.

> This thread is about the configuration API and
> not about driver performance.

I know.

I tried to show, why WEXT as a whole is still necessary even if there is
a mac80211 based driver, because of the weakness of rt2800usb:
Nip it in the bud.



Kind regards,
Andreas
