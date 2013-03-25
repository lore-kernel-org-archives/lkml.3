Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3CYBIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:08:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16924 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab3CYBId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:08:33 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-b8-514fa390deff
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1363865141.1390.120.camel@x61.thuisdomein>
In-reply-to: <1363865141.1390.120.camel@x61.thuisdomein>
Subject: RE: [PATCH] ARM: SAMSUNG: Remove useless Samsung GPIO related CONFIG
Date: Mon, 25 Mar 2013 10:08:32 +0900
Message-id: <16e101ce28f5$44aead80$ce0c0880$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4mJtQjV57Jt5ImQLqB6nzpSPavxwAvShCw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ90Ji/0DDXYu0bSYtO4Ak8Wmx9dY
	LS7vmsNmMeP8PiaL25d5LRbdOsPswObR0tzD5vF31Qtmj81L6j02bn/C5PF5k1wAaxSXTUpq
	TmZZapG+XQJXxrn/BxkLTrNXHFk7n7WBsZuti5GTQ0LAROLPo98sELaYxIV764HiXBxCAssY
	JdqvNrDDFJ1bvBysQUhgEaPE/k1aEEV/GSUmnpnPCpJgE9CQOPz+GViDiECxxOY915i6GDk4
	mAWyJba8YoLoNZdY/2E/WJhTwEKi8WQ2SFhYwFei/cRrsPEsAqoSn3/2gU3hFbCVmH+olxnC
	FpT4MfkeC8REdYkpU3JBwswC8hKb17xlBglLAIUf/dWF2G8kMenRcTaIEhGJfS/eMYIcLCFw
	i13i2stVTBCrBCS+TT7EAtErK7HpADPEs5ISB1fcYJnAKDELyeJZCItnIVk8C8mGBYwsqxhF
	UwuSC4qT0otM9YoTc4tL89L1kvNzNzFC4nTiDsb7B6wPMSYDbZ/ILCWanA+M87ySeENjMyML
	UxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MG6YGdzvvbPT6OCP
	JYs2Ht5z28+8THKzity6r/Uy065H1KqGbFih+DnfOKmLzSkyLitXi/WHMfuWdU3HvnE9lLtk
	bMmiZiUZ/tk4ielgFduNk46Gmb37mFwkjjRymh8OrSxR7f6mob60ymPrPD3LWye1WxYVM/de
	MQvKPPdrjk3U722ytXunKbEUZyQaajEXFScCAJyT/ejpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd0Ji/0DDZ4eVLWYtO4Ak8Wmx9dY
	LS7vmsNmMeP8PiaL25d5LRbdOsPswObR0tzD5vF31Qtmj81L6j02bn/C5PF5k1wAa1QDo01G
	amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0AFKCmWJOaVA
	oYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoxz/w8yFpxmrziydj5rA2M3WxcjJ4eE
	gInEucXLoWwxiQv31oPZQgKLGCX2b9LqYuQCsv8ySkw8M58VJMEmoCFx+P0zdhBbRKBYYvOe
	a0xdjBwczALZElteMUH0mkus/7AfLMwpYCHReDIbJCws4CvRfuI12HgWAVWJzz/7wKbwCthK
	zD/UywxhC0r8mHyPBWKiusSUKbkgYWYBeYnNa94yg4QlgMKP/upC7DeSmPToOBtEiYjEvhfv
	GCcwCs1CMmgWwqBZSAbNQtKxgJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwEngmtYNx
	ZYPFIUYBDkYlHl6BGv9AIdbEsuLK3EOMEhzMSiK8C/qBQrwpiZVVqUX58UWlOanFhxiTgd6c
	yCwlmpwPTFB5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cBo
	b/Z0cXr3jbnMO7oaxF/uY5n1/+eqvfaH4rU+K708bXU24ozbM9GHbLzHq36v6Mopv/kob77l
	v7nfLz5Ys+yCspBHTuCPVyLsfwVYC4x/K5ss6ix7pCX/+ctSNr70ix+Esu8URUrcecddrLeP
	bf0zthKn2tAlpu7OeQmTsgQczxrturVsYQGbEktxRqKhFnNRcSIAIZ8D0kYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> The Kconfig entry for S3C_GPIO_CFG_S3C64XX was missed by commit
> 5ec7414494ed1204c9e2ed0b8232b29860d0986f ("ARM: SAMSUNG: Remove useless
> Samsung GPIO related CONFIGs"). Remove it now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
>  arch/arm/plat-samsung/Kconfig | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
> index 663c54f..91c2d72 100644
> --- a/arch/arm/plat-samsung/Kconfig
> +++ b/arch/arm/plat-samsung/Kconfig
> @@ -117,12 +117,6 @@ config SAMSUNG_GPIOLIB_4BIT
>  	  configuration. GPIOlib shall be compiled only for S3C64XX and S5P
>  	  series of processors.
> 
> -config S3C_GPIO_CFG_S3C64XX
> -	bool
> -	help
> -	  Internal configuration to enable S3C64XX style GPIO configuration
> -	  functions.
> -
>  config S5P_GPIO_DRVSTR
>  	bool
>  	help
> --
> 1.7.11.7

Applied, thanks.

- Kukjin

