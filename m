Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbbAWHTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:19:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:42115 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbbAWHTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:19:09 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
X-AuditID: cbfee68f-f791c6d000004834-08-54c1f5de6636
Content-transfer-encoding: 8BIT
Message-id: <54C1F5DE.2060303@samsung.com>
Date: Fri, 23 Jan 2015 16:18:54 +0900
From: Jaewon Kim <jaewon02.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
To: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski.k@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>,
        Beomho Seo <beomho.seo@samsung.com>
Subject: Re: [PATCH 2/6] extcon: max77843: Add max77843 MUIC driver
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
 <1421989367-32721-3-git-send-email-jaewon02.kim@samsung.com>
 <CAJKOXPdoDZH1CmNOkZuw_Bx9pT_drP0ZrSLB8jmJpDR+sacRjg@mail.gmail.com>
In-reply-to: <CAJKOXPdoDZH1CmNOkZuw_Bx9pT_drP0ZrSLB8jmJpDR+sacRjg@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWyRsSkUPfe14MhBlev2lic/rSN3WLqwyds
	Fte/PGe1mH/kHKtF/5uFrBbnXq1ktJh0fwKLxfN/P9gt7n89ymhxedccNovPvUcYLZZev8hk
	MWH6WhaL1r1H2C1O7y5x4PdYM28No8flvl4mj52z7rJ7rFz+hc1j06pONo871/awefRtWcXo
	8XmTXABHFJdNSmpOZllqkb5dAlfGghX5BXc5Kmb+P87WwPifrYuRk0NCwESiZfFbdghbTOLC
	vfVAcS4OIYGljBIXu9exwxQ9ufEbKjGdUeLDpIVg3bwCghI/Jt9j6WLk4GAWkJc4cikbJMws
	YCbx5eVhVhBbSOA1o8Ttm4IQ5VoS9w/+YgGxWQRUJZZcO8YIYrMJaEt8X78YrF5UIEJi/rHX
	zCC2iICbxLHXf8H2Mgt8YJb433uICSQhLOAsMbV9JivEQecYJb7t2M4KcgSnQLDEyqPOEEcv
	5JA4sboMYpmAxLfJh8DulBCQldh0gBmiRFLi4IobLBMYxWYh+WYWwjezkHyzgJF5FaNoakFy
	QXFSepGxXnFibnFpXrpecn7uJkZgdJ/+96x/B+PdA9aHGAU4GJV4eBu2HAwRYk0sK67MPcRo
	CnTERGYp0eR8YArJK4k3NDYzsjA1MTU2Mrc0UxLnXSj1M1hIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDI+uR+Q+YvYXV/9UfNnAJnMNr+zghfgoj68pZuz/w6C548f2T4/qMqimmXr1dIVcu
	aC+JrXytf3ndYaXNyg8n92c+r76+tWLDsbqo3FNOe1inPc5TLWy1T/P9rnpFhrnre0IrU9qC
	jsP3NJ9aOnFybags01Lay/L8bMCTPFH1y+HPjELC0hb/UGIpzkg01GIuKk4EACwxjnTpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd17Xw+GGPw8ZmJx+tM2doupD5+w
	WVz/8pzVYv6Rc6wW/W8Wslqce7WS0WLS/QksFs///WC3uP/1KKPF5V1z2Cw+9x5htFh6/SKT
	xYTpa1ksWvceYbc4vbvEgd9jzbw1jB6X+3qZPHbOusvusXL5FzaPTas62TzuXNvD5tG3ZRWj
	x+dNcgEcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+Abpu
	mTlA1ysplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYMxasyC+4y1Ex8/9x
	tgbG/2xdjJwcEgImEk9u/IayxSQu3FsPZHNxCAlMZ5T4MGkhWIJXQFDix+R7LF2MHBzMAvIS
	Ry5lg4SZBcwkvrw8zApiCwm8ZpS4fVMQolxL4v7BXywgNouAqsSSa8cYQWw2AW2J7+sXg9WL
	CkRIzD/2mhnEFhFwkzj2+i/YXmaBD8wS/3sPMYEkhAWcJaa2z2SFOOgco8S3HdtZQY7gFAiW
	WHnUeQKjwCwk581COG8WkvMWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOHs+kdjCu
	bLA4xCjAwajEw9uw5WCIEGtiWXFl7iFGCQ5mJRHeuC9AId6UxMqq1KL8+KLSnNTiQ4ymQN9N
	ZJYSTc4HJra8knhDYxMzI0sjc0MLI2NzJXFeJfu2ECGB9MSS1OzU1ILUIpg+Jg5OqQbGsmmP
	5R0vBPO7bFCdF7SV031vhtAthlLttafL1R22lTjvuvizzC8oMv1MlKrJrYb+JVNcv/zO77wg
	WXFc5LK8pmHssn+Of2VFGd2f9QifNbB6Pc2wj71ly/1CdpXy7TyhVa48z7ZedPJc2fpJ8OkO
	Ps8irUdKFw7E3grbYrhD29jLJaVlJrMSS3FGoqEWc1FxIgAJ5PIENAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

2015년 01월 23일 15:38에 Krzysztof Kozłowski 이(가) 쓴 글:
> 2015-01-23 6:02 GMT+01:00 Jaewon Kim <jaewon02.kim@samsung.com>:
>> This patch adds MAX77843 extcon driver to support for MUIC(Micro
>> USB Interface Controller) device by using EXTCON subsystem to handle
>> various external connectors.
>>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>> ---
>>   drivers/extcon/Kconfig           |   10 +
>>   drivers/extcon/Makefile          |    1 +
>>   drivers/extcon/extcon-max77843.c |  871 ++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 882 insertions(+)
>>   create mode 100644 drivers/extcon/extcon-max77843.c
>>
> (...)
>
>> +static int max77843_muic_remove(struct platform_device *pdev)
>> +{
>> +       struct max77843_muic_info *info = platform_get_drvdata(pdev);
>> +
>> +       cancel_work_sync(&info->irq_work);
>> +
> Missing regmap_del_irq_chip().
>
> Best regards,
> Krzysztof
>

I miss remap_del_irq_chip() function. thanks.
I wil add this function.


Thanks
Jaewon Kim

