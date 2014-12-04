Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbaLDQdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:33:09 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:15624 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaLDQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:33:08 -0500
Message-ID: <54808CC1.2010502@atmel.com>
Date: Thu, 4 Dec 2014 17:33:05 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Olof Johansson <olof@lixom.net>, <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: defconfig for 3.19 #1
References: <1417537711-15608-1-git-send-email-nicolas.ferre@atmel.com> <3905790.gg6cCb9BU6@wuerfel>
In-Reply-To: <3905790.gg6cCb9BU6@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 04/12/2014 17:28, Arnd Bergmann a écrit :
> On Tuesday 02 December 2014 17:28:31 Nicolas Ferre wrote:
>>
>> The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:
>>
>>   Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-defconfig
>>
>> for you to fetch changes up to 4cd275f762a21cf21768e327873ba2883c839281:
>>
>>   ARM: at91/defconfig: add DM9000 to at91_dt (2014-12-01 16:30:00 +0100)
>>
>> ----------------------------------------------------------------
>> First batch of defconfigs for AT91 / 3.19:
>> - use NEON for all C-A5, neon code handles the !NEON case
>> - add new XDMA driver
>> - add some useful drivers as we only have a single defconfig for all
>>   AT91SAM9/RM9200
> 
> I just noticed that this is based on -rc3, while the next/defconfig branch
> so far is based on -rc1. If you don't mind, could you rebase your
> branch on -rc1 as well and send it again so I can avoid the backmerge?

Sure, I do it right now.

Stay tuned ;-)

Bye,
-- 
Nicolas Ferre
