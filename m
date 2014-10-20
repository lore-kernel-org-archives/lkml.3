Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaJTMgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:36:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:55688 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaJTMgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:36:03 -0400
Message-ID: <544501AE.7030706@atmel.com>
Date: Mon, 20 Oct 2014 14:35:58 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alessandro Zummo <a.zummo@towertech.it>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, <rtc-linux@googlegroups.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Hovold <jhovold@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 00/10] rtc: at91sam9: add DT support
References: <1411483725-31532-1-git-send-email-boris.brezillon@free-electrons.com> <20141020141748.063d6835@bbrezillon>
In-Reply-To: <20141020141748.063d6835@bbrezillon>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/10/2014 14:17, Boris Brezillon :
> Hi Alessandro,
> 
> On Tue, 23 Sep 2014 16:48:35 +0200
> Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:
> 
>> Hello,
>>
>> This patch series adds DT support to the atmel at91sam9 RTC driver.
>>
>> It also removes any machine specific inclusions to prepare the migration
>> to multi platform kernel support, and retain the slow clock to prevent
>> the CCF from disabling it at the end of boot.
> 
> Nicolas was planning to take this series (except for patch 10 which was
> already applied by Lee) in his tree for 3.19, but if you prefer to take
> it into yours just let us know.

Absolutely, I'll happily take them for at91-3.19-drivers and push them
through arm-soc tree unless Alessandro says otherwise.

Bye,
-- 
Nicolas Ferre
