Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbbAAMZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 07:25:57 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:42246 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbbAAMZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 07:25:54 -0500
X-IronPort-AV: E=Sophos;i="5.07,679,1413270000"; 
   d="scan'208";a="54003071"
Message-ID: <54A53CCE.1060906@broadcom.com>
Date: Thu, 1 Jan 2015 13:25:50 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@freenet.de>
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
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz> <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com> <54A2B807.1020202@hurleysoftware.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com> <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz> <1419971304.30412.0.camel@egrumbacBox> <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz> <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net> <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz> <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz> <54A3D955.6020809@broadcom.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DD72E@hasmsx107.ger.corp.intel.com> <54A3E1F1.7030807@broadcom.com> <alpine.LNX.2.00.1412311505100.31609@pobox.suse.cz> <54A412CE.6010803@maya.org> <54A45309.6080606@broadcom.com> <54A527CE.4000407@maya.org>
In-Reply-To: <54A527CE.4000407@maya.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/15 11:56, Andreas Hartmann wrote:
> Arend van Spriel wrote:
>> On 12/31/14 16:14, Andreas Hartmann wrote:
> [...]
>>> All in all:
>>> If you want to get rid of wext, you still have to go a *very* long way
>>> to get the same *stable* and high throughput quality with *all* chips
>>> depending on mac80211 and not just a few flagship drivers like Atheros.
>>
>> Hi Andreas,
>>
>> That's a nice list of unrelated stuff. This has all nothing to do with
>> WEXT. Actually, you can build rt5572sta with cfg80211 support
>> (RT_CFG80211_SUPPORT).
>
> You seem to know sources I don't know off. Could you please tell me,
> where to find them?
>
> I have DPO_RT5572_LinuxSTA_2.6.0.1_20120629 which doesn't compile with
> HAS_CFG80211_SUPPORT=y because -DCONFIG_AP_SUPPORT, on which
> RT_CFG80211_SUPPORT relies, is broken.
>
> DPO_RT5572_LinuxSTA_2.6.1.3_20121022 removed the necessary broken AP
> code completely.

Nice.

>> This thread is about the configuration API and
>> not about driver performance.
>
> I know.
>
> I tried to show, why WEXT as a whole is still necessary even if there is
> a mac80211 based driver, because of the weakness of rt2800usb:
> Nip it in the bud.

Yes. WEXT needs to stay for a while. Not arguing that. Just saying this 
is really about cfg80211 providing "WEXT compatibility" so WEXT 
user-space apps can interact with cfg80211-based drivers and how to come 
up with a plan to phase out "WEXT compatibility", not WEXT.

Regards,
Arend

> Kind regards,
> Andreas

