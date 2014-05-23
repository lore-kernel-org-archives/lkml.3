Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaEWSmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:42:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54814 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbaEWSmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:42:43 -0400
Message-ID: <537F9658.1040507@ti.com>
Date: Fri, 23 May 2014 21:41:28 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <lee.jones@linaro.org>,
        <santosh.shilimkar@ti.com>, <arnd@arndb.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        <sergei.shtylyov@cogentembedded.com>
Subject: Re: [Patch v7 2/7] clock: keystone-pllctrl: add bindings for keystone
 pll controller
References: <1400859812-5761-1-git-send-email-ivan.khoronzhuk@ti.com> <1400859812-5761-3-git-send-email-ivan.khoronzhuk@ti.com> <20140523183218.23136.51518@quantum>
In-Reply-To: <20140523183218.23136.51518@quantum>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/23/2014 09:32 PM, Mike Turquette wrote:
> Quoting Ivan Khoronzhuk (2014-05-23 08:43:27)
>> The main pll controller used to drive theC66x CorePacs, the switch fabric,
>> and a majority of the peripheral clocks (all but the ARM CorePacs, DDR3 and
>> the NETCP modules) requires a PLL Controller to manage the various clock
>> divisions, gating, and synchronization.
>>
>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> Acked-by: Mike Turquette <mturquette@linaro.org>
>
> Regards,
> Mike

Thanks!

-- 
Regards,
Ivan Khoronzhuk

