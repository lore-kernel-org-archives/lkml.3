Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaBHGiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 01:38:09 -0500
Received: from purkki.adurom.net ([80.68.90.206]:33070 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaBHGiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 01:38:08 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Calvin Owens <jcalvinowens@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee80211: Print human-readable disassoc/deauth reason codes
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
	<1391675824.12789.3.camel@jlt4.sipsolutions.net>
	<87r47fkrsj.fsf@purkki.adurom.net> <52F4FFD5.5070808@lwfinger.net>
	<1391811934.18534.54.camel@porter.coelho.fi>
Date: Sat, 08 Feb 2014 08:38:03 +0200
In-Reply-To: <1391811934.18534.54.camel@porter.coelho.fi> (Luca Coelho's
	message of "Sat, 08 Feb 2014 00:25:34 +0200")
Message-ID: <87mwi2kt2s.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

>> Forum, and there we are lucky if we get dmesg output. When we do and it contains 
>> a deauthentication reason, I always need to bring up a web page to interpret the 
>> output. With this change, one step could be skipped.
>
> But is it worth putting this parsing in the *kernel*? I mean, if anyone
> is interested enough in the problem, a simple google query is not that
> hard, right?

Sure, it's not hard to find it. My and Larry's point is more about
convenience and user friendliness.

On the other hand I do understand that kernel is getting bloated all the
time, for example openwrt is suffering from that. So not really sure
what is the best.

-- 
Kalle Valo
