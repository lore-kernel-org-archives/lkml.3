Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaLPQOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:14:39 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:65327 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLPQOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:14:37 -0500
MIME-Version: 1.0
In-Reply-To: <548C5F1F.8070804@roeck-us.net>
References: <1418395859-32209-1-git-send-email-matthias.bgg@gmail.com>
	<1418395859-32209-3-git-send-email-matthias.bgg@gmail.com>
	<548C5F1F.8070804@roeck-us.net>
Date: Tue, 16 Dec 2014 17:14:35 +0100
Message-ID: <CABuKBe+=PaJ2BuhoGGwn8V20207QU3zzWb4UGgXzwwF-AvBEPw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: mediatek: dts: Add bindings for watchdog
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: wim@iguana.be, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        Howard Chen <ibanezchen@gmail.com>, greta.zhang@mediatek.com,
        huang eddie <eddie.huang@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-13 16:45 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> On 12/12/2014 06:50 AM, Matthias Brugger wrote:
>>
>> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>> ---
>>   Documentation/devicetree/bindings/watchdog/mtk-wdt.txt | 13
>> +++++++++++++
>>   1 file changed, 13 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
>>
>> diff --git a/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
>> b/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
>> new file mode 100644
>> index 0000000..af9eb5b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
>> @@ -0,0 +1,13 @@
>> +Mediatek SoCs Watchdog timer
>> +
>> +Required properties:
>> +
>> +- compatible : should be "mediatek,mt6589-wdt"
>
>
> "mediatek" is undefined as vendor prefix in the current upstream code.
> Is this vendor prefix coming in from another patch set ?

Strange, should be in vendor-prefix.txt [1].
Please double check.

Thanks,
Matthias

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/vendor-prefixes.txt?id=refs/tags/v3.18#n93

>
> Guenter
>
>
>> +- reg : Specifies base physical address and size of the registers.
>> +
>> +Example:
>> +
>> +wdt: watchdog@010000000 {
>> +       compatible = "mediatek,mt6589-wdt";
>> +       reg = <0x10000000 0x18>;
>> +};
>>
>



-- 
motzblog.wordpress.com
