Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3ARBQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 20:16:37 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30913 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3ARBQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:16:34 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-7b-50f8a270c38d
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, balbi@ti.com,
        thomas.abraham@linaro.org, sylvester.nawrocki@gmail.com,
        t.figa@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, l.majewski@samsung.com,
        kyungmin.park@samsung.com, grant.likely@secretlab.ca, heiko@sntech.de,
        dianders@chromium.org, p.paneri@samsung.com, cpgs@samsung.com
References: <CAFp+6iE7zEJ7E_pRCOYz5mQqbk-MFE6Hwr02pRRT1yP+X3z7kQ@mail.gmail.com>
 <1358230225-2770-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1358230225-2770-1-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v7] usb: phy: samsung: Add support to set pmu isolation
Date: Thu, 17 Jan 2013 17:16:16 -0800
Message-id: <003001cdf519$6d21c690$476553b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFfIFOtPFr8BgNDjsIUf+5VUNUUPgJnNuz4mRhHayA=
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zfd2CRT8CDLrn6Fhc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjFZZOSmpNZllqkb5fAlTHx9DH2goWsFX+uH2JrYFzA0sXIySEhYCJx
	ofs0M4QtJnHh3no2EFtIYBmjxNcfBjA1F1fvZ+9i5AKKL2KUOLvrJZTzl1Hix7XbYB1sAhoS
	h98/YwexRQQ8JO4eWw5WxCzQyCLRfv4WO8TYCYwSjzuzQGxOoKJvWyaDrRYW8JboX3EUbBCL
	gKrE5n/7wWxeAUuJv7OfMkLYghI/Jt8DO5tZQEti87YmVghbXmLzmrdQLyhI7Dj7mhHiCCuJ
	59sWsUHUiEtMevCQHWK+gMS3yYeA5nAA1ctKbDrADHKnhMA6domLsxcyQsyRlDi44gYL0LWz
	kKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGSMRJ7WBc2WBxiFGA
	g1GJh5dL/UeAEGtiWXFl7iFGCQ5mJRFepTKgEG9KYmVValF+fFFpTmrxIUYfoMsnMkuJJucD
	k0FeSbyhsbGJmYmpibmlqbkpDmElcV7GU08ChATSE0tSs1NTC1KLYMYxcXBKNTAqtelt0f0b
	eF/HpPfasuuG65pneGw3sp5zpF/pt9/aGZs6ds1qXDR9QZlGZTe341v1h5N8up+WiZ52cpVz
	j2M9U2n9PlBkR/vPpXJKnNJSyvc8hPOU3k7y2zvndO7Zz9a/TLIXxf9adCfS6dOHXRPT2tfd
	5HXbxfE1QnXbolDpz5kLd87w2LlPiaU4I9FQi7moOBEA94lTq+UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgG7Boh8BBl3bNCwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8yYePoY
	e8FC1oo/1w+xNTAuYOli5OSQEDCRuLh6PzuELSZx4d56ti5GLg4hgUWMEmd3vWSHcP4ySvy4
	dpsNpIpNQEPi8PtnYB0iAh4Sd48tBytiFmhkkWg/fwssISQwgVHicWcWiM0JVPRty2RmEFtY
	wFuif8VRsEEsAqoSm//tB7N5BSwl/s5+yghhC0r8mHwP7DxmAS2JzduaWCFseYnNa94yQ5yq
	ILHj7GtGiCOsJJ5vW8QGUSMuMenBQ/YJjEKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3X
	UK84Mbe4NC9dLzk/dxMjOKKfSe1gXNlgcYhRgINRiYeXS/1HgBBrYllxZe4hRgkOZiURXqUy
	oBBvSmJlVWpRfnxRaU5q8SFGH6BPJzJLiSbnA5NNXkm8obGJmZGlkZmFkYm5OQ5hJXFexlNP
	AoQE0hNLUrNTUwtSi2DGMXFwSjUwbg5/1F3Jczbo7HxpAz5esQ0enY2C+/UVw6ofTfm0dca2
	yQulCrbwKUdvnWGlW7l6xou7V7rfTxCuObF5Z7ZZ6/ujritqPafrdxUWNtXLvdkXJLLNpvXk
	8hOTr8cvWuGivr/kzUWrY/tu1fHXr9947+Ya9Z47Th0fpmT6/rZR26SwJ/CtxJy/ckosxRmJ
	hlrMRcWJAKbCVoQVAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Adding support to parse device node data in order to get
> required properties to set pmu isolation for usb-phy.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

This looks good to me,
Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Vivek, could you please re-send following in one series?
- [PATCH v9 1/2] usb: phy: samsung: Introducing usb phy driver for hsotg
- [PATCH v8 2/2] usb: s3c-hsotg: Adding phy driver support

As I know, this should be applied on top of above patches.

Thanks.

- Kukjin


