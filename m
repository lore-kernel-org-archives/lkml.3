Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaLWGw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 01:52:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36778 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaLWGwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 01:52:55 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Johannes Berg <johannes.berg@intel.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] ipw2200: select CFG80211_WEXT
References: <1419271817.2317.12.camel@tiscali.nl>
Date: Tue, 23 Dec 2014 08:52:48 +0200
In-Reply-To: <1419271817.2317.12.camel@tiscali.nl> (Paul Bolle's message of
	"Mon, 22 Dec 2014 19:10:17 +0100")
Message-ID: <871tnqhn7j.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> writes:

> Commit 24a0aa212ee2 ("cfg80211: make WEXT compatibility unselectable")
> made it impossible to depend on CFG80211_WEXT. It does still allow to
> select that symbol. (Yes, the commit summary is confusing.)
>
> So make IPW2200 select CFG80211_WEXT, so that the ipw2200 driver can be
> built again.

I think the last sentence is a bit misleading (this isn't a compilation
error, right?) and I would like to clarify it like this:

"So make IPW2200 select CFG80211_WEXT, so that the ipw2200 driver can be
enabled in config again."

Does that look ok?

-- 
Kalle Valo
