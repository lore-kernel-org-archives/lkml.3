Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbbAVD7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:59:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:18579 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbbAVD7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:59:21 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-cb-54c075909fdc
Message-id: <54C07590.9080707@samsung.com>
Date: Thu, 22 Jan 2015 12:59:12 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
MIME-version: 1.0
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, lee.jone@linaro.org,
        broonie@kernel.org, dbaryshkov@gmail.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v3 1/2] power: rt5033_charger: Add RT5033 charger device
 driver
References: <1421887092-4070-1-git-send-email-beomho.seo@samsung.com>
 <1421887092-4070-2-git-send-email-beomho.seo@samsung.com>
 <20150122031240.GA17627@earth.universe>
In-reply-to: <20150122031240.GA17627@earth.universe>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsWyRsSkWHdC6YEQg5V71SymPnzCZnH9y3NW
	i0lP3jNbzD9yjtVi4srJzBb9bxayWpx7tZLRYtL9CSwW7/ecYbS4vGsOm8Xn3iOMFkuvX2Sy
	mDB9LYtF694j7Band5dYzJj8ks1BwGPNvDWMHpf7epk8ds66y+6xcvkXNo/NK7Q8Nq3qZPO4
	c20Pm0ffllWMHp83yQVwRnHZpKTmZJalFunbJXBlLDiYV/CBteLng6NsDYyXWboYOTkkBEwk
	Zh1tY4ewxSQu3FvP1sXIxSEksJRR4vqEflaYoutdZxkhEtMZJb517mKBcF4zSnzfOxmsildA
	S+LG0RmMIDaLgKrE/jXTmUFsNgFNifdTroCtExWIkJh/7DUzRL2gxI/J98DiIgJqEu8vPQUb
	yizwj0ni1tpmsKHCAqESB46/Z4XYtppR4uCUiWAbOIFuat3ZBXQsB1CHnsT9i1ogYWYBeYnN
	a94yg9RLCKzkkLj3YxI7xEUCEt8mH2IBqZcQkJXYdIAZ4jVJiYMrbrBMYBSbheSmWQhTZyGZ
	uoCReRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYNSf/vdswg7GewesDzEKcDAq8fC+UNwf
	IsSaWFZcmXuI0RToiInMUqLJ+cDUklcSb2hsZmRhamJqbGRuaaYkzvta6mewkEB6Yklqdmpq
	QWpRfFFpTmrxIUYmDk6pBsb65Rn6TCyWO/aJ+6v/sLNuaZTbfNL1rGRMKKfhoXWq5emPPty/
	YxraKPmr+7584iOW6jvb3ac3S7m63A0Kid3AwX3YWdyu1uJa7vaN7RZymabiK7ds3jLxQ/oX
	vX8VWiF94Qwy25uDVF8F7MqdpXxA8svm1ncpE0xaalLS/9ddEZdjuXxZV4mlOCPRUIu5qDgR
	AJDKe1f1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jQd0JpQdCDH7/kLWY+vAJm8X1L89Z
	LSY9ec9sMf/IOVaLiSsnM1v0v1nIanHu1UpGi0n3J7BYvN9zhtHi8q45bBafe48wWiy9fpHJ
	YsL0tSwWrXuPsFuc3l1iMWPySzYHAY8189Ywelzu62Xy2DnrLrvHyuVf2Dw2r9Dy2LSqk83j
	zrU9bB59W1YxenzeJBfAGdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCX
	mJtqq+TiE6DrlpkD9IaSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWPB
	wbyCD6wVPx8cZWtgvMzSxcjJISFgInG96ywjhC0mceHeerYuRi4OIYHpjBLfOnexQDivGSW+
	753MClLFK6AlcePoDLAOFgFVif1rpjOD2GwCmhLvp1wBmyoqECEx/9hrZoh6QYkfk++BxUUE
	1CTeX3oKNpRZ4B+TxK21zWBDhQVCJQ4cf88KsW01o8TBKRPBNnAC3de6swvoJg6gDj2J+xe1
	QMLMAvISm9e8ZZ7AKDALyY5ZCFWzkFQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGc
	Up5J72Bc1WBxiFGAg1GJh/eF4v4QIdbEsuLK3EOMEhzMSiK8HhoHQoR4UxIrq1KL8uOLSnNS
	iw8xmgJDYCKzlGhyPjDd5ZXEGxqbmBlZGpkbWhgZmyuJ8yrZt4UICaQnlqRmp6YWpBbB9DFx
	cEo1MIr+u903PeaH4N54sZ/SH5r1vBlXmj27tmbuwgzRKL6QFy/9zhwO/Ndsf85lY044E/OP
	LwIVSnt4F38LZp81+e3jhLy6S7dCjuU9Sm6Z8zvWdJVD+FbNfzXK8VOnV66fVTahV5eT/2Q1
	a4X4REkdwUkmsSfa5oel7l6++UizU6idw48Jyj0BnkosxRmJhlrMRcWJAKpsHTU/AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for review.

On 01/22/2015 12:12 PM, Sebastian Reichel wrote:
> Hi,
> 
> On Thu, Jan 22, 2015 at 09:38:11AM +0900, Beomho Seo wrote:
>> This patch add device driver of Richtek RT5033 PMIC. The driver
>> support switching charger. rt5033 charger provide three charging
>> mode.  Three charging mode are pre charge mode, fast cahrge mode
>> and constant voltage mode. They are have vary charge rate, charge
>> parameters. The charge parameters can be controlled by i2c
>> interface.
>>
>> [...]
>>
>> +	charger->psy.name = "rt5033-charger",
>> +	charger->psy.type = POWER_SUPPLY_TYPE_BATTERY,
>>
>> [...]
> 
> POWER_SUPPLY_TYPE_MAINS?
> 
> -- Sebastian
> 

OK I will change power supply type.

Thanks,
Beomho Seo

