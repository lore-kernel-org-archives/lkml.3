Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbaLWKzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:55:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52693 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaLWKzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:55:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] ipw2200: select CFG80211_WEXT
References: <1419271817.2317.12.camel@tiscali.nl>
	<1419330521.6091.1.camel@sipsolutions.net>
Date: Tue, 23 Dec 2014 12:55:11 +0200
In-Reply-To: <1419330521.6091.1.camel@sipsolutions.net> (Johannes Berg's
	message of "Tue, 23 Dec 2014 11:28:41 +0100")
Message-ID: <87oaqueiuo.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2014-12-22 at 19:10 +0100, Paul Bolle wrote:
>> Commit 24a0aa212ee2 ("cfg80211: make WEXT compatibility unselectable")
>> made it impossible to depend on CFG80211_WEXT. It does still allow to
>> select that symbol. (Yes, the commit summary is confusing.)
>> 
>> So make IPW2200 select CFG80211_WEXT, so that the ipw2200 driver can be
>> built again.
>> 
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> Johannes,
>> 
>> Building v3.19-rc1 for an outdated ThinkPad X41 left me without the
>> ipw2200 driver. It turns out this trivial patch is all that's needed to
>> make ipw2200 buildable again.
>> 
>> (A similar patch would be needed for the drivers behind Kconfig symbol
>> HERMES. Ie, orinico and friends.) 
>
> Yeah, config HERMES needs the same change.
>
> Kalle, do you want to take those through your tree, or should I fix it
> seeing that I introduced the bug in a sense?

To keep things simple I would prefer to take this through
wireless-drivers.git, if it's ok for you.

-- 
Kalle Valo
