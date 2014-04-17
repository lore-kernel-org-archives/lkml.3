Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbaDQKPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:15:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29895 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaDQKPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:15:06 -0400
X-AuditID: cbfee68e-b7f566d000002344-03-534fa9a88a98
Message-id: <534FA9AD.7000406@samsung.com>
Date: Thu, 17 Apr 2014 19:15:09 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        =?UTF-8?B?67CV7LCs7Zi4?= <chanho61.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        marc.zyngier@arm.com,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2 5/8] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
 <1397527192-21988-6-git-send-email-cw00.choi@samsung.com>
 <CAHbNUh3m7n1OT9fc715vth=k6BdAvVZoYJjBvo8xT25TPji18w@mail.gmail.com>
In-reply-to: <CAHbNUh3m7n1OT9fc715vth=k6BdAvVZoYJjBvo8xT25TPji18w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42JZI2JSrLtypX+wwfv9jBZ/Jx1jt5i07gCT
	xeX92hbzj5xjtfj8oYXdonfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZ3L7Ma/H3zj82i1PX
	PwOFJr9ks1g/4zWLxbEZSxgt2v/uZbPYu3Myo4OQx5p5axg9Wpp72Dx+/5rE6PF31QtmjzvX
	9rB5bF5S73HlRBOrR9+WVYwenzfJBXBGcdmkpOZklqUW6dslcGVcuPiDtWAjd8XUK5tYGxiv
	cXQxcnBICJhItDaZdjFyApliEhfurWfrYuTiEBJYyiixuOkRO0TCROL+ndmMEIlFjBK71r9k
	hXBeM0rc3reYGaSKV0BLon3lKxYQm0VAVWLBy59g3WxA8f0vbrCB2KICYRIrp19hgagXlPgx
	+R6YLSKgI/Fg0V4WkKHMAutYJa7/7WEESQgLBEh82X4O6qYTjBJHPmxiArmbUyBYYtJmeZAa
	ZgF1iUnzFjFD2PISm9e8ZQaplxA4wCHR0DuNCeIiAYlvkw+xQPwsK7HpADPEa5ISB1fcYJnA
	KDYLyU2zkIydhWTsAkbmVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxiBieD0v2d9OxhvHrA+
	xJgMtHIis5Rocj4wkeSVxBsamxlZmJqYGhuZW5qRJqwkzrvoYVKQkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBsZKrqXCtmH73vV1d3amsaRGi9S92DXRdinXvQqVLOmzzPNeC3dmTuv+GSaa
	ccjy3b+8qB8Rdqmn3ykacooXblzibLVz8YqvesfPGXjxB+/q4hQNOtfBWKnsUvpp5bPa14I5
	L+/fvhnEojZdWfDtUfsLD2P57EQW/XKfenv2MvN5p/QOqzy4/UeJpTgj0VCLuag4EQBxCz6b
	GgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jAd0VK/2DDTb+NLH4O+kYu8WkdQeY
	LC7v17aYf+Qcq8XnDy3sFr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/J4vZlXou/d/6xWZy6
	/hkoNPklm8X6Ga9ZLI7NWMJo0f53L5vF3p2TGR2EPNbMW8Po0dLcw+bx+9ckRo+/q14we9y5
	tofNY/OSeo8rJ5pYPfq2rGL0+LxJLoAzqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHyWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1G
	BmggYQ1jxoWLP1gLNnJXTL2yibWB8RpHFyMnh4SAicT9O7MZIWwxiQv31rN1MXJxCAksYpTY
	tf4lK4TzmlHi9r7FzCBVvAJaEu0rX7GA2CwCqhILXv5kB7HZgOL7X9xgA7FFBcIkVk6/wgJR
	LyjxY/I9MFtEQEfiwaK9LCBDmQXWsUpc/9sDtlpYIEDiy/ZzUKtPMEoc+bCJqYuRg4NTIFhi
	0mZ5kBpmAXWJSfMWMUPY8hKb17xlnsAoMAvJjllIymYhKVvAyLyKUTS1ILmgOCk911CvODG3
	uDQvXS85P3cTIzjRPJPawbiyweIQowAHoxIP7wR1/2Ah1sSy4srcQ4wSHMxKIrwSK4BCvCmJ
	lVWpRfnxRaU5qcWHGJOBQTCRWUo0OR+YBPNK4g2NTcyMLI3MDS2MjM1JE1YS5z3Qah0oJJCe
	WJKanZpakFoEs4WJg1OqgdEiTywwTeFHd0BnogZjcryS67W5MWY7/NJ3fPzx0/nJikK7L98/
	NwuWSPhV/992JEDvS1WnPk9NO881Pc3zjM2Cu1RTP2q/b6oQ+vnmz+fpxzdwLEraU8m66Ous
	r6J/lKQ2rcpU8nvW94rzru2dPRZfnzdbPXm+1TzncY7Bz1tRz178NJzEMEOJpTgj0VCLuag4
	EQByWL+heAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tushar,

On 04/15/2014 02:09 PM, Tushar Behera wrote:
> On 15 April 2014 07:29, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch fix the offset of CPU boot address and don't operate smc call
>> of SMC_CMD_CPU1BOOT command for Exynos3250.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/mach-exynos/firmware.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
>> index aa01c42..6205d4f 100644
>> --- a/arch/arm/mach-exynos/firmware.c
>> +++ b/arch/arm/mach-exynos/firmware.c
>> @@ -30,13 +30,16 @@ static int exynos_do_idle(void)
>>
>>  static int exynos_cpu_boot(int cpu)
>>  {
>> +       if (soc_is_exynos3250()) {
>> +               return 0;
>>         /*
>>          * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
>>          * But, Exynos4212 has only one secondary CPU so second parameter
>>          * isn't used for informing secure firmware about CPU id.
>>          */
>> -       if (soc_is_exynos4212())
>> +       } else if (soc_is_exynos4212()) {
>>                 cpu = 0;
>> +       }
>>
> 
> As you already return in case of Exynos3250, you need not change this.
> First commit hunk without the opening brace should be sufficient.

OK, I'll remove brace.

Best Regards,
Chanwoo Choi

