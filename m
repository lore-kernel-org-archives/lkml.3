Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3CFIkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:40:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11857 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3CFIkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:40:33 -0500
X-AuditID: cbfee690-b7f6b6d000004563-74-513700ff9f6c
Date: Wed, 06 Mar 2013 08:40:21 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 05/32] lib: devres: don't enclose pcim_*() functions in
 CONFIG_HAS_IOPORT
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Lior Amsalem <alior@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eran Ben-Avi <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130306083901521@jg1.han
Msgkey: 20130306083901521@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130306083901521@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <22387327.428751362559215433.JavaMail.weblogic@epml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJsWRmVeSWpSXmKPExsVy+t8zI93/DOaBBsd/CFhc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMeNplVbCJp+LPzs9sDYwtPF2MnBxCAkoSk07uZexi5OCQEDCReL/D
	GiQsISAmceHeerYuRi6gkmWMEqvWfWWHSJhITN3dwQbRO59R4tD6TBCbRUBFYu/v+WBxNgF1
	iQm/m1lAbGGBWIldt+6A9YoI2EhsvL6cEWQos0Azh8SJiZ3MEINkJe5Nng1m8woISpyc+YQF
	4iAFiT2zgkBMXgFFiaa+YIgTJCTu3N/PCmHzSsxof8oCYctJTPu6hhnClpY4P2sDI8wvi78/
	horzSxy7vYMJYjqvxJP7wTBjdm/+wgZhC0hMPXMQqlVVYtfRLVCtfBJrFr6FWiUocfpaNzNM
	b8PG32AfMgNdOaX7IZStJfHlxz42VE+B2E4SvyfsZ5nAqDwLSWoWkvZZSNqR1SxgZFnFKJpa
	kFxQnJReZIIc05sYIQlwwg7GewesDzHuZwRGyURmKdHkfGAKzSuJNzQ2NjEzMTUxtzQ1N6VA
	2NzI1ACYTA0MqSOsJM4rf0kmUEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjPK9g5XMXic28
	EwIsLq0xL3WIT0uQ1N44WSV1/6mmuFrt9l+ejgtalQ/07NybMfNHXIAq/zKevt1XJc6++B7l
	+9o4bQKb1x12Ta7vf33kq8Ov1y8W1H35fcJqvbfr1zVPfawj+89J182MzaIj4JL2EX7WgvCJ
	R8rTb/3Iyak/emrWB+8yZwklluKMREMt5qLiRADxUQHb8wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tmbr/GcwDDVYs47G4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnrGlrFWhgYGRqZAVQkZ
	GU+7rAo28VT82fmZrYGxhaeLkZNDSEBJYtLJvYwgtoSAicTU3R1sELaYxIV769kgauYzShxa
	nwliswioSOz9PR8sziagLjHhdzMLiC0sECux69YddhBbRMBGYuP15UAzuTiYBZo5JE5M7GSG
	GCQrcW/ybDCbV0BQ4uTMJ0DNHEDLFCT2zAoCMXkFFCWa+oIhTpCQuHN/PyuEzSsxo/0pC4Qt
	JzHt6xpmCFta4vysDYwwJy/+/hgqzi9x7PYOJojpvBJP7gfDjNm9+QvUhwISU88chGpVldh1
	dAtUK5/EmoVvoVYJSpy+1s0M09uw8TfYh8xAV07pfghla0l8+bGPDdVTILaTxO8J+1kmMMrN
	QpKahaR9FpJ2ZDULGFlWMYqmFiQXFCelVxjrFSfmFpfmpesl5+duYgQnp2eLdzD+P299iFGA
	g1GJh3eCilmgEGtiWXFl7iFGCQ5mJRFerjNAId6UxMqq1KL8+KLSnNTiQ4zJwPibyCwlmpwP
	TJx5JfGGxsYmZiam5gYWBpbmpAkrifOG2KgHCgmkJ5akZqemFqQWwWxh4uCUamBsWMc4pylu
	yu1szvdW5gIZzn+sQtky9VhSrh1bvfrkzLVzfOsWPshpjNt5IKGKu9mxM2yVrrQLn/gO5hBZ
	hX9Z26Ydv6grMMWfySt4bbXFK+mabwZbIvMnxZ77muU3O/z2sumZK4w3rt/Qq7VzBkuW9/bC
	W4s3RmpfVDnZEfFA+9spA9/vZZ+VWIozEg21mIuKEwGWXor8kgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r268eaoN013049

On Wednesday, March 06, 2013 5:26 PM, Thomas Petazzoni wrote:
> 
> Dear Jingoo Han,
> 
> On Wed, 06 Mar 2013 06:28:08 +0000 (GMT), Jingoo Han wrote:
> 
> > Sorry, I did not know that you submitted the patch.
> 
> No problem, I'm happy to have one less patch to carry in my PCIe patch
> set :)

Thank you :)

> 
> > Like you, I am developing PCIe Host driver.
> 
> Just curious, do you already have some code? Thierry Reding and myself
> have been looking at each other's PCIe host driver since a while in
> order to make some consistent choices where possible. It would be good
> to see your code as well.

Yes, I am developing a PCIe driver for Samsung Exynos SoCs.
Also, 2 days ago, I submitted the PCIe driver.

http://www.spinics.net/lists/linux-pci/msg20548.html
http://www.spinics.net/lists/linux-pci/msg20549.html

If someone look at my code, it will be very helpful.
Thank you :)

Best regards,
Jingoo Han

> 
> Best regards,
> 
> Thomas
> --
> Thomas Petazzoni, Free Electrons
> Kernel, drivers, real-time and embedded Linux
> development, consulting, training and support.
> http://free-electrons.com
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
