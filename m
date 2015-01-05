Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbbAEWNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:13:15 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:41667 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbbAEWNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:13:13 -0500
X-IronPort-AV: E=Sophos;i="5.07,702,1413270000"; 
   d="scan'208";a="54047393"
Message-ID: <54AB0C75.1090204@broadcom.com>
Date: Mon, 5 Jan 2015 23:13:09 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "ipw2200: select CFG80211_WEXT"
References: <1420297188.2397.3.camel@tiscali.nl>	 <CD467A59-F563-439B-BA82-954AB27AD9CC@holtmann.org>	 <CA+55aFzYSiUkntraMrHEhMzkt35Ft2p9E3cT7ejwQOBDwKvcOg@mail.gmail.com>	 <1420324124.9624.60.camel@x220> <54AA641C.7050307@broadcom.com>	 <1420479510.14308.23.camel@x220>	 (sfid-20150105_183907_807502_81C08416) <1420484224.9459.16.camel@sipsolutions.net> <1420495519.14308.29.camel@x220>
In-Reply-To: <1420495519.14308.29.camel@x220>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/15 23:05, Paul Bolle wrote:
> On Mon, 2015-01-05 at 19:57 +0100, Johannes Berg wrote:
>> Multiple other groups of ioctls could be converted in similar patches,
>> until at the end you can completely remove ipw_wx_handlers and rely
>> entirely on cfg80211's wext compatibility.
>>
>> So far the theory - in practice nobody cared enough to start working on
>> any of these drivers, let alone actually has the hardware today.
>
> So my suggestion to make ipw2200 no longer use cfg80211_wext_giwname()
> would actually be backwards. What's actually needed, in theory, is to
> use more of what's provided under CFG80211_WEXT (and, I guess, less of
> what's provided under WIRELESS_EXT). Did I get that right?

Yes, but as Johannes indicated it needs consideration what to group in 
the patches.

Regards,
Arend

> Thanks,
>
>
> Paul Bolle
>

