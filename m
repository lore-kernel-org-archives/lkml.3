Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3LJPrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:47:00 -0500
Received: from purkki.adurom.net ([80.68.90.206]:40477 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab3LJPq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:46:58 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Dec 2013 10:46:58 EST
From: Kalle Valo <kvalo@adurom.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH v2 02/16] wl1251: add sysfs interface for bluetooth coexistence mode configuration
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	<1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
	<1386494714-21070-3-git-send-email-pali.rohar@gmail.com>
Date: Tue, 10 Dec 2013 17:46:54 +0200
In-Reply-To: <1386494714-21070-3-git-send-email-pali.rohar@gmail.com> ("Pali
	=?utf-8?Q?Roh=C3=A1r=22's?= message of "Sun, 8 Dec 2013 10:25:00 +0100")
Message-ID: <87y53spv2p.fsf@purkki.adurom.net>
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
> Port the bt_coex_mode sysfs interface from wl1251 driver version included
> in the Maemo Fremantle kernel to allow bt-coexistence mode configuration.
> This enables userspace applications to set one of the modes
> WL1251_BT_COEX_OFF, WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO.
> The default mode is WL1251_BT_COEX_OFF.
> It should be noted that this driver always enabled bt-coexistence before
> and enabled bt-coexistence directly affects the receiving performance,
> rendering it unusable in some low-signal situations. Especially monitor
> mode is affected very badly with bt-coexistence enabled.
>
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

I think this is also what I wrote a long time. And also this sysfs hack
should not go to upstream.

Over the years there has been some talk about solving the BT coex
properly, but I haven't seen any patches. I guess the proper solution
would be that BT subsystem in kernel would notify wireless drivers about
BT use?

-- 
Kalle Valo
