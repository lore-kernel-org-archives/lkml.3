Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaDQBAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 21:00:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65192 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaDQBAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 21:00:31 -0400
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
X-AuditID: cbfee68e-b7f566d000002344-22-534f27ab4d01
Content-transfer-encoding: 8BIT
Message-id: <534F27B0.4060709@samsung.com>
Date: Thu, 17 Apr 2014 10:00:32 +0900
From: Sangjung <sangjung.woo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
To: sw0312.kim@samsung.com
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] extcon: arizona: Use devm_extcon_dev_register()
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
 <1397644023-32516-9-git-send-email-sangjung.woo@samsung.com>
 <534E5F09.8070703@samsung.com>
In-reply-to: <534E5F09.8070703@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWyRsSkQHe1un+wwZpZEhbXvzxntbi8aw6b
	xe3GFWwWMya/ZHNg8ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6M2xsPMxac4a44/fQlSwPj
	Ec4uRk4OCQETib63T9khbDGJC/fWs3UxcnEICSxllFiwci4TTNHahzeYIBKLGCV+LT3BCJLg
	FRCU+DH5HksXIwcHs4C8xJFL2SBhZgENiamvTzNC1L9mlHj+fB8rSA2vgJbE4aNBIDUsAqoS
	B/evBJvPJqAp8fn4QTYQW1QgQmLuxM1gtoiAlMT/Q/dZIcYXShy4GgwSFhbwkLj2oJkZYvwK
	Ron+ln5mkASngLbEzr7HYHdKCKxil5j24RcrxDIBiW+TD4HdKSEgK7HpADPEX5ISB1fcYJnA
	KDYLyTezEL6ZheSbBYzMqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzEC4+b0v2d9OxhvHrA+
	xJgMtHEis5Rocj4w7vJK4g2NzYwsTE1MjY3MLc1IE1YS5130MClISCA9sSQ1OzW1ILUovqg0
	J7X4ECMTB6dUA6OXuHycqYp7rCyv2ZcTBl9/FHyavFL9rLKdxa2GM1tWPuYzFqtvVihg0BTN
	+din+0VH8Kz3cSbeD588vPbz8Ex3C7GcfGpmQwfrd63tnBe/Tlw6zX3W0rNLMvcnzVpSOcHA
	gLkzYT2bcPrJIoPd//n+5mcdVQlVmH1kYcHCPSI7rLUEV/QvX6nEUpyRaKjFXFScCABqWnJh
	sQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAd3V6v7BBrN+C1pc//Kc1eLyrjls
	FrcbV7BZzJj8ks2BxaNvyypGj8+b5AKYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCWsYM25vPMxYcIa74vTTlywNjEc4uxg5OSQETCTWPrzBBGGLSVy4t56ti5GLQ0hgEaPE
	r6UnGEESvAKCEj8m32PpYuTgYBaQlzhyKRskzCygITH19WlGiPrXjBLPn+9jBanhFdCSOHw0
	CKSGRUBV4uD+lWDz2QQ0JT4fP8gGYosKREjMnbgZzBYRkJL4f+g+K8T4QokDV4NBwsICHhLX
	HjQzQ4xfwSjR39LPDJLgFNCW2Nn3mGkCo8AsJNfNQrhuFpLrFjAyr2IUTS1ILihOSs810itO
	zC0uzUvXS87P3cQIjspn0jsYVzVYHGIU4GBU4uHl/O0XLMSaWFZcmXuIUYKDWUmE113cP1iI
	NyWxsiq1KD++qDQntfgQYzLQcxOZpUST84EJI68k3tDYxMzI0sjc0MLI2Jw0YSVx3oOt1oFC
	AumJJanZqakFqUUwW5g4OKUaGCuOJ9hpnFbJNlqux3Xy281z84+f6ZzkEV7xYl6trYZFt+SN
	muCnFzbftjxX6ei0ZM/15+Jyd0xPnGW7UKr0oVzTdYmLzwzbY2Ivd14qkc/ZyCfywUdzwl43
	5vi/QlIvzl664/FSlevo57i2XTZagqELqxd39Ozabdv/0qjmcbmxyRlV9tW/3JVYijMSDbWY
	i4oTAetr1BAOAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To Seung-Woo.


On 04/16/2014 07:44 PM, Seung-Woo Kim wrote:
> Hi,
>
> On 2014³â 04¿ù 16ÀÏ 19:27, Sangjung Woo wrote:
>> Use the resource-managed extcon device register function (i.e.
>> devm_extcon_dev_register()) instead of extcon_dev_register(). If extcon device
>> is attached with this function, that extcon device is automatically unregistered
>> on driver detach. That reduces tiresome managing code.
>>
>> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
>> ---
>>  drivers/extcon/extcon-arizona.c |   13 ++++---------
>>  1 file changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
>> index 98a14f6..40e6c0b 100644
>> --- a/drivers/extcon/extcon-arizona.c
>> +++ b/drivers/extcon/extcon-arizona.c
>> @@ -1105,15 +1105,13 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>>  	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>>  	if (!info) {
>>  		dev_err(&pdev->dev, "Failed to allocate memory\n");
>> -		ret = -ENOMEM;
>> -		goto err;
>> +		return -ENOMEM;
>>  	}
>>  
>>  	info->micvdd = devm_regulator_get(arizona->dev, "MICVDD");
>>  	if (IS_ERR(info->micvdd)) {
>> -		ret = PTR_ERR(info->micvdd);
>>  		dev_err(arizona->dev, "Failed to get MICVDD: %d\n", ret);
> Assignment to ret is removed but it is still used here.

You're right.
I will fix and send it as second version.

Thank you for your comment.

BRs,
Sangjung
