Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaEVRRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:17:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48096 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaEVRRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:17:32 -0400
Message-ID: <537E30E0.8050403@ti.com>
Date: Thu, 22 May 2014 20:16:16 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <santosh.shilimkar@ti.com>,
        <arnd@arndb.de>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>,
        <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        <sergei.shtylyov@cogentembedded.com>
Subject: Re: [Patch v6 3/7] mfd: ti-keystone-devctrl: add bindings for device
 state control
References: <1400777062-19276-1-git-send-email-ivan.khoronzhuk@ti.com> <1400777062-19276-4-git-send-email-ivan.khoronzhuk@ti.com> <20140522171148.GL19747@lee--X1>
In-Reply-To: <20140522171148.GL19747@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/22/2014 08:11 PM, Lee Jones wrote:
> On Thu, 22 May 2014, Ivan Khoronzhuk wrote:
>
>> The Keystone II devices have a set of registers that are used to control
>> the status of its peripherals. This node is intended to allow access to
>> this functionality.
>>
>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> ---
>>   .../devicetree/bindings/mfd/ti-keystone-devctrl.txt   | 19 +++++++++++++++++++
>>   1 file changed, 19 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt
> Applied, thanks.
>

Thanks.

-- 
Regards,
Ivan Khoronzhuk

