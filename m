Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaGIH1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:27:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44017 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaGIH1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:27:32 -0400
X-AuditID: cbfee690-b7fb56d000003439-86-53bceee1677f
Message-id: <53BCEEE1.4010403@samsung.com>
Date: Wed, 09 Jul 2014 16:27:29 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: kgene.kim@samsung.com
Cc: Jonathan Cameron <jic23@kernel.org>, ch.naveen@samsung.com,
        t.figa@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sachin.kamat@linaro.org,
        kyungmin.park@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv5 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and
 code clean
References: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
 <53AFFD69.8060702@kernel.org> <53B0C2AB.4030201@samsung.com>
In-reply-to: <53B0C2AB.4030201@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsWyRsSkRPfhuz3BButbpC3uPj/MaDH/yDlW
	i/43C1ktzr1ayWjxoGkVk0XvgqtsFmeb3rBbzDvyjsXi8q45bBYzzu9jslh6/SKTxYTpa1ks
	3t6ZzmLRuvcIu8XJP72MFutnvGZxEPBYM28No8flvl4mj5XLv7B5bF6h5bFpVSebx51re9g8
	+rasYvT4vEkugCOKyyYlNSezLLVI3y6BK+Peuz2MBTuEK+YumMbcwLiTv4uRk0NCwETi8N7/
	LBC2mMSFe+vZuhi5OIQEljJK/Oifwt7FyAFWNH1lBEiNkMAiRomDkwIhal4zSkyZuJYZpIZX
	QEti2+EwkBoWAVWJ580L2UBsNqDw/hc3wGxRgTCJldOvgO3iFRCU+DH5HpgtIiAp0dTwhxlk
	JrPAJGaJK09fMIIkhAUiJJ7f28sMsayFUWLyx4usIAlOAW2J5gmHwWxmAR2J/a3T2CBseYnN
	a96CNUgILOWQWDhtNSPESQIS3yYfYoH4RlZi0wFmiI8lJQ6uuMEygVFsFpKjZiEZOwvJ2AWM
	zKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAqP99L9nE3Yw3jtgfYgxGWjlRGYp0eR8YLLI
	K4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGuctF
	Yg+alHKZjgS+2tcotpqhS0rYS297U6bzldDfbeKh1nK3BXNeTTSTbRU4mxda8PX/8T0f+RQ2
	pIXGm6+tN3v5e2eOdcayph/uXeuzSpsdvE4Vvjw3x23BZ5vgzUnWmvXhfNkFZUuect9P3tm9
	8HzcIq3teyYos522dZ8itfL209NtEQ5KLMUZiYZazEXFiQAWSL9SDAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd2H7/YEG8z+Kmhx9/lhRov5R86x
	WvS/Wchqce7VSkaLB02rmCx6F1xlszjb9IbdYt6RdywWl3fNYbOYcX4fk8XS6xeZLCZMX8ti
	8fbOdBaL1r1H2C1O/ulltFg/4zWLg4DHmnlrGD0u9/Uyeaxc/oXNY/MKLY9NqzrZPO5c28Pm
	0bdlFaPH501yARxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZK
	Lj4Bum6ZOUAvKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz7r3bw1iw
	Q7hi7oJpzA2MO/m7GDk4JARMJKavjOhi5AQyxSQu3FvPBmILCSxilDg4KbCLkQvIfs0oMWXi
	WmaQel4BLYlth8NAalgEVCWeNy8Eq2cDCu9/cQPMFhUIk1g5/QoLiM0rICjxY/I9MFtEQFKi
	qeEPM8hMZoFJzBJXnr5gBEkIC0RIPL+3lxliWQujxOSPF1lBEpwC2hLNEw6D2cwCOhL7W6ex
	QdjyEpvXvGWewCgwC8mSWUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOJU8
	k97BuKrB4hCjAAejEg+vAs+eYCHWxLLiytxDjBIczEoivN/cgEK8KYmVValF+fFFpTmpxYcY
	TYFhMJFZSjQ5H5jm8kriDY1NzIwsjcwNLYyMzZXEeQ+2WgcKCaQnlqRmp6YWpBbB9DFxcEo1
	MIbmzmp51nyBKf06Z4Vd8lT+z/nNHA2e173Kg2Yu4LlUFNGed3/mkulHPTKNPlnLesyzeJqp
	a15ut689zkZD4RSXmnr7h8uH/9T/+pK4ozuQgevKkWT7P/851rdwZe+5NtvmoKl+wle9dxuV
	zyU7tCVfPrbyH9uUN4JLLcty/Ix291usyU/zV2Ipzkg01GIuKk4EACVwq1g7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin Kim,

This patch modified Exynos3250 dtsi to support ADC with IIO.
Could you please reivew this patchset about exynos3250.dtsi?

Best Regards,
Chanwoo Choi

On 06/30/2014 10:51 AM, Chanwoo Choi wrote:
> Dear Kukjin,
> 
> On 06/29/2014 08:50 PM, Jonathan Cameron wrote:
>> On 27/06/14 05:30, Chanwoo Choi wrote:
>>> Changes from v4:
>>> - Use 'exynos_adc_data' structure instead of 'exynos_adc_ops' structure
>>>    and remove enum variable of ADC version
>>> - Fix wrong name of special clock (sclk_tsadc -> sclk_adc)
>>> - Add reviewed message by Naveen Krishna Chatradhi
>>> - Add functions for ADC clock control
>>>
>>> Changes from v3:
>>> - Add new 'exynos_adc_ops' structure to improve readability according to
>>>   Tomasz Figa comment[1]
>>>   [1] https://lkml.org/lkml/2014/4/16/238
>>> - Add new 'exynos3250-adc-v2' compatible string to support Exynos3250 ADC
>>> - Fix wrong compaitlbe string of ADC in Exynos3250 dtsi file
>>>
>>> Changes from v2:
>>> - Check return value of clock function to deal with error exception
>>> - Fix minor coding style to improve readability
>>>
>>> Changes from v1:
>>> - Add new "samsung,exynos-adc-v3" compatible to support Exynos3250 ADC
>>> - Add a patch about DT binding documentation
>>>
>>> Chanwoo Choi (4):
>>>    iio: adc: exynos_adc: Add exynos_adc_data structure to improve readability
>>>    iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
>>>    iio: devicetree: Add DT binding documentation for Exynos3250 ADC
>>>    ARM: dts: Fix wrong compatible string for Exynos3250 ADC
>>>
>>>   .../devicetree/bindings/arm/samsung/exynos-adc.txt |  26 +-
>>>   arch/arm/boot/dts/exynos3250.dtsi                  |   4 +-
>>>   drivers/iio/adc/exynos_adc.c                       | 326 +++++++++++++++------
>>>   3 files changed, 268 insertions(+), 88 deletions(-)
>>>
>> I am happy with this series, but given it touches some exynos bindings, I would
>> like an ack from Kukjin Kim (or according to MAINTAINERS Ben Dooks) before taking it
>> all through IIO.
> 
> Could you please review this patchset about exynos dtsi and bindings?
> 
> Best Regards,
> Chanwoo Choi
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

