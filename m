Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3FQIeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:34:17 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:53397 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3FQIeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:34:16 -0400
From: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
CC: "balbi@ti.com" <balbi@ti.com>,
        "richard.genoud@gmail.com" <richard.genoud@gmail.com>,
        "Shen, Voice" <Voice.Shen@atmel.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>
Subject: RE : [GIT PULL] at91: Device Tree update for 3.11 #2
Thread-Topic: [GIT PULL] at91: Device Tree update for 3.11 #2
Thread-Index: AQHOaWr5F2F0Mv64c0e4b6pxWjkaOJk5lv56
Date: Mon, 17 Jun 2013 08:34:11 +0000
Message-ID: <EABCC4A72A203F4BA2E04297CF0282C427D1E112@hnombx01.corp.atmel.com>
References: <1370279139-7181-1-git-send-email-nicolas.ferre@atmel.com>
 <1371250067-19317-1-git-send-email-nicolas.ferre@atmel.com>,<20130615015224.GA25585@quad.lixom.net>
In-Reply-To: <20130615015224.GA25585@quad.lixom.net>
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


>On Sat, Jun 15, 2013 at 12:47:47AM +0200, Nicolas Ferre wrote:
>> Arnd, Olof,
>>
>> Additional pull-request for AT91 DT patches.
>> It contains the remaining part of the USB gadget pull-request that I sent you
>> last week. After having split it, here is the DT part.
>> It also contains the update of DMA bindings: it is the AT91 part the should go
>> through arm-soc. I have included the patch (ARM: at91: dt: add header to define
>> at_hdmac configuration) so that we avoid build errors whichever git tree
>> (slave-dma or arm-soc) is merged first.
>> A SPI DT patch for at91sam9x5 is also added.
>>
>> Thanks, best regards,
>>
>> The following changes since commit 028633c238f91dc113520a7ad25d37b2ba9068af:
>>
>>   ARM: at91/dt: add pinctrl definition for at91 tc blocks (2013-05-31 22:40:37 +0200)
>>
>> are available in the git repository at:
>>
>>   git://github.com/at91linux/linux-at91.git tags/at91-dt
>
>Pulled, thanks.

Hi,

I do not see it appearing in arm-soc/at91/dt branch even though is it present in arm-soc/for-next: is it normal?

Bye,
-- 
Nicolas Ferre