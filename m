Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaGVMOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:14:45 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:45280 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841AbaGVMOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:14:12 -0400
Message-ID: <53CE556C.10607@st.com>
Date: Tue, 22 Jul 2014 14:13:32 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <chris@printf.net>, <ulf.hansson@linaro.org>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, <khilman@linaro.org>
Cc: <devicetree@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <kernel@stlinux.com>
Subject: Re: [STLinux Kernel] [PATCH v3 10/10] MAINTAINERS: Add sdhci-st file
 to ARCH/STI architecture
References: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>	<1401899424-1365-11-git-send-email-peter.griffin@linaro.org> <53A80754.9000900@st.com>
In-Reply-To: <53A80754.9000900@st.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-22_04:2014-07-22,2014-07-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof, Arnd, Kevin,

	I am preparing two tags for v3.17 regarding STi platform.
	One for DT, and one for defconfigs.

	Except this one, I have no patches for ARM-SoC.
	Can you take this patch directly?

	Or should I send a pull request with this one only?

Regards,
Maxime

On 06/23/2014 12:54 PM, Maxime Coquelin wrote:
>
>
> On 06/04/2014 06:30 PM, Peter Griffin wrote:
>> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
>
> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
>
>> --- MAINTAINERS | 1 + 1 file changed, 1 insertion(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS index 6dc67b1..19dc265
>> 100644 --- a/MAINTAINERS +++ b/MAINTAINERS @@ -1306,6 +1306,7 @@ F:
>> drivers/pinctrl/pinctrl-st.c F:	drivers/media/rc/st_rc.c F:
>> drivers/i2c/busses/i2c-st.c F:	drivers/tty/serial/st-asc.c +F:
>> drivers/mmc/host/sdhci-st.c
>>
>> ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT M:	Lennert Buytenhek
>> <kernel@wantstofly.org>
>>
>
>
>
> _______________________________________________
> Kernel mailing list
> Kernel@stlinux.com
> http://www.stlinux.com/mailman/listinfo/kernel
>
