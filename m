Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3FQJFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:05:55 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:55816 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab3FQJFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:05:54 -0400
From: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
CC: "balbi@ti.com" <balbi@ti.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>
Subject: RE : [GIT PULL v3] at91: USBA DT support / drivers update for 3.11
 #1
Thread-Topic: [GIT PULL v3] at91: USBA DT support / drivers update for 3.11
 #1
Thread-Index: AQHOaWyOPuPyVfD9NkauoQBirj4nLJk5mz9l
Date: Mon, 17 Jun 2013 09:05:50 +0000
Message-ID: <EABCC4A72A203F4BA2E04297CF0282C427D1E181@hnombx01.corp.atmel.com>
References: <1370279139-7181-1-git-send-email-nicolas.ferre@atmel.com>
 <1371247364-23213-1-git-send-email-nicolas.ferre@atmel.com>,<20130615020343.GB25585@quad.lixom.net>
In-Reply-To: <20130615020343.GB25585@quad.lixom.net>
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
>On Sat, Jun 15, 2013 at 12:02:44AM +0200, Nicolas Ferre wrote:
>> Arnd, Olof,
>>
>> This is a rework of the previous pull-request done by Jean-Christophe
>> PLAGNIOL-VILLARD ([GIT PULL] at91: USBA DT support for 3.11).
>> It is also the division of my previous pull request (v2) to extract only
>> patches related to drivers. The DT patches will be stacked on top of our
>> arm-soc/at91/dt branch in an upcoming pull-request.
>> You should see that this material is based on the cleanup branch that you
>> already have in arm-soc/at91/cleanup.
>>
>> This adds the DT support for USBA gadget driver present in the most recent
>> AT91 SoCs.
>> As agreed with Arnd and Felipe we send these drivers updates via arm-soc.
>>
>> Thanks, best regards,
>>
>> The following changes since commit b3f442b0eedbc20b5ce3f4a96530588d14901199:
>>
>>   ARM: at91: udpate defconfigs (2013-05-17 15:05:08 +0200)
>>
>> are available in the git repository at:
>>
>>   git://github.com/at91linux/linux-at91.git tags/at91-drivers
>
>Pulled, thanks. This had conflicts with some code from fixes. The change/remove
>ones were easy (cs-gpio vs interrupts), but there was one dealing with pinctrl.
>PLease double-check that there wasn't a need to carry over a fix to the
>include-file-based version.

I have just double-checked and your resolution about pinctrl is right. Thanks a lot Olof.
(note that I do not see the arm-soc/at91/drivers branch...)

Bye,