Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbbAFID5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:03:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48733 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbbAFIDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:03:55 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "ipw2200: select CFG80211_WEXT"
References: <1420297188.2397.3.camel@tiscali.nl>
Date: Tue, 06 Jan 2015 10:03:44 +0200
In-Reply-To: <1420297188.2397.3.camel@tiscali.nl> (Paul Bolle's message of
	"Sat, 03 Jan 2015 15:59:48 +0100")
Message-ID: <87d26s1gkf.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> writes:

> This reverts commit dddd60220f41775e634258efd1b54c6fa81ce706.
>
> The raison d'être of commit dddd60220f41 ("ipw2200: select
> CFG80211_WEXT") was reverted in commit 2d36e008739e ("Revert "cfg80211:
> make WEXT compatibility unselectable""). So revert this commit too.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Based on the discussion I have dropped this patch from my queue.

-- 
Kalle Valo
