Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaBYFZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 00:25:36 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:51485 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaBYFZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 00:25:34 -0500
X-AuditID: cbfee690-b7f266d00000287c-ac-530c294bf1e5
Date: Tue, 25 Feb 2014 05:25:31 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH V8 1/2] PHY: Exynos: Add Exynos5250 SATA PHY driver
To: kishon@ti.com, yuvaraj.cd@samsung.com
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, grant.likely@linaro.org, robh+dt@kernel.org,
        swarren@wwwdotorg.org, mark.rutland@arm.com, yuvaraj.cd@gmail.com,
        ks.giri@samsung.com, vasanth.a@samsung.com,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20140225051516731@jg1.han
Msgkey: 20140225051516731@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140225051516731@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <10341096.99771393305930937.JavaMail.weblogic@epml25>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsVy+t8zI11vTZ5ggzXb1Swu75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJmzN7Vz1rQw1PR1fOJrYHxAXcXIyeHkICSxKSTexlBbAkBE4lVzaeZ
	IGwxiQv31rN1MXIB1SxjlGje1QdX1L7uIytEYj6jRO+ONlaQBIuAqsScg33sIDabgLrEhN/N
	LCC2sIC7xPNlh8BsEQFTicPfN7KANDMLrGCW+DNzHzvEGbIS9ybPZgaxeQUEJU7OfAJUxAG0
	TUGi6aIlRFhRYuqEvawQR0hI3Lm/H8rmlZjR/pQFwpaTmPZ1DTOELS1xftYGRphvFn9/DBXn
	lzh2ewcTxHheiSf3g2HG7N78hQ3CFpCYeuYgVKuqxJdNt6HifBJrFr6FWiUocfpaNzNM7/0t
	c8EBxwx05pTuh+wQtpbElx/72FB9BWI7SnzcNIt9AqPyLCSpWUjaZyFpR1azgJFlFaNoakFy
	QXFSepEJcmxvYoQkwgk7GO8dsD7EuJ8RGCcTmaVEk/OBqTSvJN7Q2MzIwtTE1NjI3NKMQmET
	UwsLEyOqCCuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwNhp8+j01y8OnOErOzZ9
	Ctx4138qJ/dBaaXdp/0+V0y69WNVzNWDrUytd5Xi3YqljKduPsn6X3lmgMv6HSXqsUxLvn6s
	+pjqf5Sp+8TncMU09eszvS6/XMoQ/TvmQPjWp9EWcjsEa+K/2jxNCkhbwuRy80jZKSauqfI3
	OXckdO7naWG9I5Sw20iJpTgj0VCLuag4EQDaI0RG9wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2TF1vTZ5ggzW/lSwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6xZayVoYGBkSlQVUJG
	xuxd/awFPTwVXT2f2BoYH3B3MXJyCAkoSUw6uZcRxJYQMJFoX/eRFcIWk7hwbz1bFyMXUM18
	RoneHW1gCRYBVYk5B/vYQWw2AXWJCb+bWUBsYQF3iefLDoHZIgKmEoe/b2QBaWYWWMEs8Wfm
	PnaIbbIS9ybPZgaxeQUEJU7OfAJUxAG0TUGi6aIlRFhRYuqEvVBHSEjcub8fyuaVmNH+lAXC
	lpOY9nUNM4QtLXF+1gZGmKMXf38MFeeXOHZ7BxPEeF6JJ/eDYcbs3vyFDcIWkJh65iBUq6rE
	l023oeJ8EmsWvoVaJShx+lo3M0zv/S1zmUBsZqAzp3Q/ZIewtSS+/NjHhuorENtR4uOmWewT
	GOVmIUnNQtI+C0k7spoFjCyrGEVTC5ILipPSK4z0ihNzi0vz0vWS83M3MYJT1LNFOxj/nbc+
	xCjAwajEw9tRzB0sxJpYVlyZe4hRgoNZSYQ3RIQnWIg3JbGyKrUoP76oNCe1+BBjMjACJzJL
	iSbnA9NnXkm8obGxiZmJqbmBhYGlOWnCSuK88reSgoQE0hNLUrNTUwtSi2C2MHFwSjUwZuvP
	aEmRfPJISoN7HV+r1ue+yCqRANncvU/1Pp+508Ib+L3+jR53wLvaxuJFW4/+OFv16nfbgq7N
	FgHlV7ZrvG/UNrN41LzB5/qEF51vlzx4tHj1hN9d6X31e1xDP8uVrj6rkvW4Xmm6aqhU1yV+
	R93cKn2ZBzOCXr3ic1IMuXRN6rjBx3mNSizFGYmGWsxFxYkAtlhesZUDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1P5Pfhm020028

On Mon, 24 Feb 2014 19:26:44, Kishon Vijay Abraham I wrote: 
> On Monday 24 February 2014 07:02 PM, Yuvaraj Kumar C D wrote:
> > This patch adds the SATA PHY driver for Exynos5250.Exynos5250 SATA
> > PHY comprises of CMU and TRSV blocks which are of I2C register Map.
> > So this patch also adds a i2c client driver, which is used configure
> 
> We no longer have i2c client driver here.

Right.

> > the CMU and TRSV block of exynos5250 SATA PHY.
> > 
> > This patch incorporates the generic PHY framework to deal with SATA
> > PHY.
> 
> It should be rephrased to have *uses* generic PHY framework. However I feel we
> can do away with this line.

Right, "incorporates" is confusing.

> > 
> > This patch depends on the below patch for the sata functionality
> > 	[1].ata: ahci_platform: Manage SATA PHY
> > 		by Roger Quadros <rogerq@xxxxxx>
> 
> hasn't this patch merged yet?

Currently, this patch was queued into libata tree, for-next. [1]

[1] http://git.kernel.org/cgit/linux/kernel/git/tj/libata.git/commit/?h=for-next&id=21b5faeec229d4f70a7f60a7b0b065c98198f491

Best regards,
Jingoo HanˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
