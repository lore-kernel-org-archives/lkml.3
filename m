Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbbALKv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:51:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:59216 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbALKvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:51:25 -0500
X-AuditID: cbfee68e-f79b46d000002b74-33-54b3a72adbc6
Message-id: <54B3A72A.8020700@samsung.com>
Date: Mon, 12 Jan 2015 19:51:22 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sre@kernel.org, lee.jone@linaro.org,
        broonie@kernel.org, dbaryshkov@gmail.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        beomho.seo@samsung.com
Subject: Re: [PATCH v2 0/3] power: rt5033: Add Richtek RT533 drivers
References: <1420793114-20586-1-git-send-email-beomho.seo@samsung.com>
 <1421059225.22660.33.camel@x220>
In-reply-to: <1421059225.22660.33.camel@x220>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkUFdr+eYQg7PXTSxOf9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBb9bxayWpx7tZLRYtL9CSwW7/ecYbS4vGsOm8Xn3iOMFkuvX2Sy
	mDB9LYvFoltnmC1a9x5htzi9u8RixuSXbBafmtuYHYQ81sxbw+hxua+XyWPnrLvsHiuXf2Hz
	2LSqk83jzrU9bB59W1Yxemzc/oTJ4/MmuQDOKC6blNSczLLUIn27BK6Mez2L2Qq6hSruP/zM
	2MDYx9fFyMkhIWAiMfnxZSYIW0ziwr31bF2MXBxCAksZJSaf+MAKU/TmQysTRGIRo8Ti/qOs
	EM5rRomdqxayg1TxCmhJfNv6G2wUi4CqxILP88C62QQ0Jd5PucICYosKREh8WPWVDaJeUOLH
	5HtgcREBZYnWzffA5jALbGSWWPEtGcQWFnCRmPH3LDOILSSQKfHh91ugeg4OTgFdiflPPEFM
	ZgF1iSlTciE65SU2r3nLDHKahMAeDom3P1ezQZwjIPFt8iGwVgkBWYlNB5gh/pKUOLjiBssE
	RrFZSA6ahTB1FpKpCxiZVzGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIEpoHT/5717WC8ecD6
	EKMAB6MSD6+F1OYQIdbEsuLK3EOMpkBHTGSWEk3OByabvJJ4Q2MzIwtTE1NjI3NLMyVx3gSp
	n8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGFXd418kONo9KJJubGPMvX/95YZNfoVVRTND
	il9IpFyNn7Hb6taaPWFJb16Lc2WkHSzM7y4M/Td331HPJyy1U0+ofJ3xonhv4Tv7ye/51mnN
	TODN38V/Y+NMJkZ24wtz/HyEFh1d6hVh3SQ/N1loxvfVIisijX1/mCS923wg/eLdomfX5q+U
	m6vEUpyRaKjFXFScCAAsVOPf/gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAV2t5ZtDDP7M0bY4/Wkbu8XUh0/Y
	LK5/ec5qMenJe2aL+UfOsVr0v1nIanHu1UpGi0n3J7BYvN9zhtHi8q45bBafe48wWiy9fpHJ
	YsL0tSwWi26dYbZo3XuE3eL07hKLGZNfsll8am5jdhDyWDNvDaPH5b5eJo+ds+6ye6xc/oXN
	Y9OqTjaPO9f2sHn0bVnF6LFx+xMmj8+b5AI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNN
	zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsS
	BNdjZIAGEtYwZtzrWcxW0C1Ucf/hZ8YGxj6+LkZODgkBE4k3H1qZIGwxiQv31rN1MXJxCAks
	YpRY3H+UFcJ5zSixc9VCdpAqXgEtiW9bf4N1sAioSiz4PI8VxGYT0JR4P+UKC4gtKhAh8WHV
	VzaIekGJH5PvgcVFBJQlWjffA5vDLLCRWWLFt2QQW1jARWLG37PMILaQQKbEh99vgeo5ODgF
	dCXmP/EEMZkF1CWmTMmF6JSX2LzmLfMERoFZSBbMQqiahaRqASPzKkbR1ILkguKk9FwjveLE
	3OLSvHS95PzcTYzgJPNMegfjqgaLQ4wCHIxKPLwWUptDhFgTy4orcw8xSnAwK4nwupYBhXhT
	EiurUovy44tKc1KLDzGaAr0/kVlKNDkfmADzSuINjU3MjCyNzA0tjIzNlcR5lezbQoQE0hNL
	UrNTUwtSi2D6mDg4pRoYXbecay1fs6T+rL3I6uVRa39es5w791xOSMji8BVPlhlfXaLQ6TGx
	KtHt1fq7ofMnyAkePigjKVK4xKXHLuj83LAFVtkaMfe/u6tkv8rq7hQoKLXOUlh68furKd1m
	m5bG554UWWt9707zRIWqvJ/r522+cmLi0eCFs61k7x312eZReT8g5GJotxJLcUaioRZzUXEi
	AL7VubRIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you reply.

On 01/12/2015 07:40 PM, Paul Bolle wrote:
> Beomho,
> 
> On Fri, 2015-01-09 at 17:45 +0900, Beomho Seo wrote:
>> This patchset adds driver for Richtek rt5033 chip The chip contains
>> switching charge mode Li-Ion/Li-Polymer battery charger, fuelgauge.
>> Additionally, This includes document for device tree of RT5033 device.
>>
>> RT5033 core driver is applied by Lee Jones.
>> RT5033 regulator driver have been merged by Mark Brown. commit is below,
>>
>> commit b1917578fd5d8efa67afa05a0d6d7e323f2802da
>>
>> Changes in v2:
>> - Revise binding documentation..
>>  
>> Beomho Seo (3):
>>   power: rt5033_battery: Add RT5033 Fuel gauge device driver
>>   power: rt5033_charger: Add RT5033 charger device driver
>>   Documentation: Add documentation for rt5033 multifunction device
>>
>>  Documentation/devicetree/bindings/mfd/rt5033.txt   |  101 ++++
>>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>>  drivers/power/Kconfig                              |   16 +
>>  drivers/power/Makefile                             |    2 +
>>  drivers/power/rt5033_battery.c                     |  177 +++++++
>>  drivers/power/rt5033_charger.c                     |  485 ++++++++++++++++++++
>>  6 files changed, 782 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
>>  create mode 100644 drivers/power/rt5033_battery.c
>>  create mode 100644 drivers/power/rt5033_charger.c
> 
> This series adds two drivers that depend on MFD_RT5033. But there's
> currently no Kconfig symbol MFD_RT5033.
> 
> The regulator driver mentioned above is another driver that depends on
> MFD_RT5033. It was included first in next-20141117. It is also included
> in mainline since v3.19-rc1. That regulator driver has never been
> buildable, even if one bypasses its dependency on MFD_RT5033. That is
> because it includes two headers that are not yet part of the tree
> (linux/mfd/rt5033.h and linux/mfd/rt5033-private.h).
> 
> When is the Kconfig symbol MFD_RT5033 expected to be included in the
> tree?
> 
> 
> Paul Bolle
> 
> 

MFD_RT5033 have been applied in 09 Dec 2014.
http://marc.info/?l=linux-pm&m=141822463218774&w=2
According to the mail, That is expected to include next version.

Best regards,
Beomho Seo
