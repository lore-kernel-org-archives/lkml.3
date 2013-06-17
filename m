Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab3FQJVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:21:00 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:57841 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3FQJU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:20:58 -0400
From: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
To: Olof Johansson <olof@lixom.net>
CC: Arnd Bergmann <arnd@arndb.de>, "Yang, Wenyou" <Wenyou.Yang@atmel.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>
Subject: RE : [GIT PULL] at91: soc updates for 3.11 #1
Thread-Topic: [GIT PULL] at91: soc updates for 3.11 #1
Thread-Index: AQHOaXE19iNPtIYNVECDlEqBeLxxqpk5owpC
Date: Mon, 17 Jun 2013 09:20:55 +0000
Message-ID: <EABCC4A72A203F4BA2E04297CF0282C427D1E1F8@hnombx01.corp.atmel.com>
References: <1371246138-22207-1-git-send-email-nicolas.ferre@atmel.com>,<20130615023702.GA8635@quad.lixom.net>
In-Reply-To: <20130615023702.GA8635@quad.lixom.net>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.161.30.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson [olof@lixom.net]
>Hi,
>
>On Fri, Jun 14, 2013 at 11:42:18PM +0200, Nicolas Ferre wrote:
>> Arnd, Olof,
>>
>> A little AT91 pull-request for patches that are more targeted to SoC/boards
>> modifications. It is prepared on top of the arm-soc/at91/cleanup branch.
>>
>> Thanks, best regards,
>>
>> The following changes since commit b3f442b0eedbc20b5ce3f4a96530588d14901199:
>>
>>   ARM: at91: udpate defconfigs (2013-05-17 15:05:08 +0200)
>>
>> are available in the git repository at:
>>
>>   git://github.com/at91linux/linux-at91.git tags/at91-soc
>>
>> for you to fetch changes up to 7e75545ea7fb972c3da759f92c3d0be84d1cee72:
>>
>>   ARM: at91: drop rm9200dk board support (2013-06-14 23:34:11 +0200)
>>
>> ----------------------------------------------------------------
>> Two non critical fixes that can go in 3.11.
>> An old board removed.
>>
>> ----------------------------------------------------------------
>> Alexandre Belloni (1):
>>       ARM: at91: Fix link breakage when !CONFIG_PHYLIB
>
>Fix
>
>> Jean-Christophe PLAGNIOL-VILLARD (1):
>>       ARM: at91: drop rm9200dk board support
>
>Cleanup
>
>> Wenyou Yang (1):
>>       ARM: at91: Change the internal SRAM memory type MT_MEMORY_NONCACHED
>
>Fix
>
>...assuming, of course, that none of the fixes are for errors introduced in
>some branch we already pulled, since then they should go on top of that branch.

I do agree with you but:
1/ the fixes are non-critical ones, so I do not see the need for another branch
2/ I didn't feel like touching the "cleanup" branch because we want to base all our 3.11 material on top of it, without adding new patches on top.

But, tell me if you think that it is too cautious...

Bye,
-- 
Nicolas Ferre