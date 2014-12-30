Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaL3OiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 09:38:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:48508 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbaL3OiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 09:38:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,666,1413270000"; 
   d="scan'208";a="644565129"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Peter Hurley <peter@hurleysoftware.com>,
        Emmanuel Grumbach <egrumbach@gmail.com>, Jiri Kosina <jkosina@suse.cz>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: iwlwifi-driver card doesn't work with 3.19-rc2+
Thread-Topic: iwlwifi-driver card doesn't work with 3.19-rc2+
Thread-Index: AQHQJDU+EoR5axQUzE2MSpVrm+daTJyoDkqAgAADSYCAACHJYA==
Date: Tue, 30 Dec 2014 14:38:02 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com>
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz>
 <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>
 <54A2B807.1020202@hurleysoftware.com>
In-Reply-To: <54A2B807.1020202@hurleysoftware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBUEcIIS021100

> 
> On 12/30/2014 09:23 AM, Emmanuel Grumbach wrote:
> > On Tue, Dec 30, 2014 at 3:33 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> >>
> >> Hi,
> >>
> >> I just booted current Linus' tree (5faa0154fe33) on my x200s
> >> thinkpad, and wifi doesn't work. iwconfig is telling me that wlan0
> >> interface has no wireless extensions.
> >>
> >
> > So why do you used them?
> > They have been deprecated for a couple of years now. You should be
> > using nl80211 based tools such as iw.
> 
> A couple of years is not very long where userspace is concerned.
> 
Well - the decently new wireless tools do talk nl80211.
You can still enable it (CFG80211_WEXT).
It has been disabled by:

commit 24a0aa212ee2dbe44360288684478d76a8e20a0a
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Nov 28 12:14:06 2014 +0100

    cfg80211: make WEXT compatibility unselectable
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
