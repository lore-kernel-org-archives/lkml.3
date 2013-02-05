Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab3BEFk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:40:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:26022 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3BEFk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:40:28 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-d1-51109b4a1795
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Olof Johansson'" <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1360025290-16278-1-git-send-email-tobetter@gmail.com>
In-reply-to: <1360025290-16278-1-git-send-email-tobetter@gmail.com>
Subject: RE: [PATCH] ARM: dts: Adding RTC device node
Date: Mon, 04 Feb 2013 21:40:14 -0800
Message-id: <125101ce0363$46e2fe10$d4a8fa30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGArHU6K6rOOjzOAcRgIEab0kn3t5kFbYmA
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zfV2v2QKBBpvviVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mn5vPMxa0sFWs3fGfsYHxBUsXIyeHhICJRP/+iWwQtpjEhXvr
	gWwuDiGBZYwS1z++YIMpun3kNCtEYhGjxPTnuxkhnHlMEofWvgcbxSagIXH4/TN2EFtEQE2i
	8W8nWAezwBRGidVvvzCBJIQEnCTmnm5lBbE5BZwl9t27xQhiCwuYSkw89R+smUVAVeLHzydg
	q3kFLCUuTpzDAmELSvyYfA/MZhbQkli/8zgThC0vsXnNW2aIUxUkdpx9zQhxhJHE2+ZnzBA1
	4hKTHjxkh6hZxC4x/78GxC4BiW+TDwHN5ACKy0psOgA1RlLi4IobLBMYJWYh2TwLyeZZSDbP
	QrJhASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYyQ6JLawbiyweIQowAHoxIP74/L/IFC
	rIllxZW5hxglOJiVRHg/3gAK8aYkVlalFuXHF5XmpBYfYkwGOnYis5Rocj4w8vNK4g2NjU3M
	TExNzC1NzU1JE1YS52U89SRASCA9sSQ1OzW1ILUIZgsTB6dUA6NLPNeMedWb1ZfaxvS+iDiu
	YeDes/u9CU9/9qQQj5kzxQJXT2PI5qpg3GK0e8Zl6fq9DYYnN6WuLnk/9f6daWeUK6oXCR4R
	jj9zWE9h3RsL1afMDOoBKyJEnDcumGDn8yyde/vby+8dbr6Ru2bhX6/NzCXk6HRdI/ts8szH
	B74uk9R5WM/v80OJpTgj0VCLuag4EQC4rW5J8gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgK7XbIFAgwW7BC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxs/N5xkLWtgq1u74z9jA
	+IKli5GTQ0LAROL2kdOsELaYxIV769m6GLk4hAQWMUpMf76bEcKZxyRxaO17sA42AQ2Jw++f
	sYPYIgJqEo1/O1lBipgFpjBKrH77hQkkISTgJDH3dCvYWE4BZ4l9924xgtjCAqYSE0/9B2tm
	EVCV+PHzCRuIzStgKXFx4hwWCFtQ4sfke2A2s4CWxPqdx5kgbHmJzWveMkOcqiCx4+xrRogj
	jCTeNj9jhqgRl5j04CH7BEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJERy9z6R2MK5ssDjEKMDBqMTD++Myf6AQa2JZcWXuIUYJDmYlEd6PN4BCvCmJlVWp
	RfnxRaU5qcWHGJOBPp3ILCWanA9MLHkl8YbGJmZGlkZmFkYm5uakCSuJ8zKeehIgJJCeWJKa
	nZpakFoEs4WJg1OqgTFtWu1FqTllseZ5ep0B+816Rc/m9HMvqP7TcLk95ktYXMaJJDuO/gWy
	VuF9YjyN+ev0au5GLNQUu6epvaDw5TsRZd9+QybZrbySpTd7Zmpn+OyJi+O5/OpQxEsrxyrJ
	xaeMJXgnqP/aJPyn/bvH23NyN5/6m7Ndeqp7zWnWr1tsawUXWxY0KLEUZyQaajEXFScCADp8
	NysiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongjin Kim wrote:
> 
> This patch enables RTC device node defined in
> arch/arm/boot/dts/exynos4.dtsi.
> 
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  arch/arm/boot/dts/exynos4412-odroidx.dts |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts
> b/arch/arm/boot/dts/exynos4412-odroidx.dts
> index 54fe32f..85c958a 100644
> --- a/arch/arm/boot/dts/exynos4412-odroidx.dts
> +++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
> @@ -83,6 +83,10 @@
>  		regulator-boot-on;
>  	};
> 
> +	rtc@10070000 {
> +		status = "okay";
> +	};
> +
>  	sdhci@12530000 {
>  		bus-width = <4>;
>  		pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
> --
> 1.7.10.4

Applied, thanks.

- Kukjin

