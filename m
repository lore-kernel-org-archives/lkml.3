Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbaLWK2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:28:47 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:37995 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbaLWK2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:28:46 -0500
Message-ID: <1419330521.6091.1.camel@sipsolutions.net>
Subject: Re: [PATCH RFC] ipw2200: select CFG80211_WEXT
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 23 Dec 2014 11:28:41 +0100
In-Reply-To: <1419271817.2317.12.camel@tiscali.nl> (sfid-20141222_191040_534124_837C59D7)
References: <1419271817.2317.12.camel@tiscali.nl>
	 (sfid-20141222_191040_534124_837C59D7)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-22 at 19:10 +0100, Paul Bolle wrote:
> Commit 24a0aa212ee2 ("cfg80211: make WEXT compatibility unselectable")
> made it impossible to depend on CFG80211_WEXT. It does still allow to
> select that symbol. (Yes, the commit summary is confusing.)
> 
> So make IPW2200 select CFG80211_WEXT, so that the ipw2200 driver can be
> built again.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Johannes,
> 
> Building v3.19-rc1 for an outdated ThinkPad X41 left me without the
> ipw2200 driver. It turns out this trivial patch is all that's needed to
> make ipw2200 buildable again.
> 
> (A similar patch would be needed for the drivers behind Kconfig symbol
> HERMES. Ie, orinico and friends.) 

Yeah, config HERMES needs the same change.

Kalle, do you want to take those through your tree, or should I fix it
seeing that I introduced the bug in a sense?

johannes

