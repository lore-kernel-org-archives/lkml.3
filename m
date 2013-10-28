Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3J1Fxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:53:55 -0400
Received: from purkki.adurom.net ([80.68.90.206]:59435 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab3J1Fxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:53:53 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH 01/16] mac80211: fix TX device statistics for monitor interfaces
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	<1382819655-30430-2-git-send-email-pali.rohar@gmail.com>
Date: Mon, 28 Oct 2013 07:53:45 +0200
In-Reply-To: <1382819655-30430-2-git-send-email-pali.rohar@gmail.com> ("Pali
	=?utf-8?Q?Roh=C3=A1r=22's?= message of "Sat, 26 Oct 2013 22:34:00 +0200")
Message-ID: <87iowiszyu.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pali Rohár <pali.rohar@gmail.com> writes:

> From: David Gnedt <david.gnedt@davizone.at>
>
> Count TX packets and bytes also for monitor interfaces.
>
> Signed-of-by: David Gnedt <david.gnedt@davizone.at>

You should send mac80211 patches separately, not inside a wl1251 patchset.

-- 
Kalle Valo
