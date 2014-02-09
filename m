Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaBIUDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:03:50 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751889AbaBIUDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:03:48 -0500
Message-ID: <52F7DF21.70207@nod.at>
Date: Sun, 09 Feb 2014 21:03:45 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>, Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "open list:ATHEROS ATH5K WIR..." <linux-wireless@vger.kernel.org>,
        "open list:ATHEROS ATH5K WIR..." <ath5k-devel@venema.h4ckr.net>,
        open@hauke-m.de,
        "list@hauke-m.de:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/28] Remove ATHEROS_AR231X
References: <1391971686-9517-1-git-send-email-richard@nod.at> <1391971686-9517-10-git-send-email-richard@nod.at> <52F7D480.1050106@hauke-m.de>
In-Reply-To: <52F7D480.1050106@hauke-m.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.02.2014 20:18, schrieb Hauke Mehrtens:
> On 02/09/2014 07:47 PM, Richard Weinberger wrote:
>> The symbol is an orphan, get rid of it.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  drivers/net/wireless/ath/ath5k/Kconfig | 10 +++++-----
>>  drivers/net/wireless/ath/ath5k/ath5k.h | 28 ----------------------------
>>  drivers/net/wireless/ath/ath5k/base.c  | 14 --------------
>>  drivers/net/wireless/ath/ath5k/led.c   |  7 -------
>>  4 files changed, 5 insertions(+), 54 deletions(-)
>>
> 
> This code is used in OpenWrt with an out of tree arch code for the
> Atheros 231x/531x SoC. [0] I do not think anyone is working on adding
> this code to mainline Linux kernel, because of lack of time/interest.

Sorry, we don't maintain out of tree code.

Thanks,
//richard
