Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaBJMFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:05:49 -0500
Received: from mail-yk0-f170.google.com ([209.85.160.170]:47400 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaBJMFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:05:45 -0500
MIME-Version: 1.0
In-Reply-To: <52F7DF21.70207@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391971686-9517-10-git-send-email-richard@nod.at> <52F7D480.1050106@hauke-m.de>
 <52F7DF21.70207@nod.at>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Mon, 10 Feb 2014 16:05:24 +0400
Message-ID: <CAHNKnsS7Mv4ZhBWZa53go9L9nZimJ7_FG5HFJ9C3kkGMAEz-mA@mail.gmail.com>
Subject: Re: [PATCH 09/28] Remove ATHEROS_AR231X
To: Richard Weinberger <richard@nod.at>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jonathan Bither <jonbither@gmail.com>,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "open list:ATHEROS ATH5K WIR..." <linux-wireless@vger.kernel.org>,
        "open list:ATHEROS ATH5K WIR..." <ath5k-devel@venema.h4ckr.net>,
        open@hauke-m.de,
        "list@hauke-m.de:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-10 0:03 GMT+04:00 Richard Weinberger <richard@nod.at>:
> Am 09.02.2014 20:18, schrieb Hauke Mehrtens:
>> On 02/09/2014 07:47 PM, Richard Weinberger wrote:
>>> The symbol is an orphan, get rid of it.
>>>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>> ---
>>>  drivers/net/wireless/ath/ath5k/Kconfig | 10 +++++-----
>>>  drivers/net/wireless/ath/ath5k/ath5k.h | 28 ----------------------------
>>>  drivers/net/wireless/ath/ath5k/base.c  | 14 --------------
>>>  drivers/net/wireless/ath/ath5k/led.c   |  7 -------
>>>  4 files changed, 5 insertions(+), 54 deletions(-)
>>>
>>
>> This code is used in OpenWrt with an out of tree arch code for the
>> Atheros 231x/531x SoC. [0] I do not think anyone is working on adding
>> this code to mainline Linux kernel, because of lack of time/interest.
>
> Sorry, we don't maintain out of tree code.
>

Oleksij, Jonathan do you still working to make ar231x devices work
with upstream, since your posts [1, 2]? Or may be someone from OpenWRT
team would like to add upstream support?

1. https://lkml.org/lkml/2013/5/13/321
2. https://lkml.org/lkml/2013/5/13/358

-- 
BR,
Sergey
