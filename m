Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3ILK0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:26:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13938 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3ILK0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:26:00 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-5a-523196b69167
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Mohit KUMAR DCG'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002801ce8376$a807dbf0$f81793d0$@samsung.com>
 <51ED49D6.9050209@ti.com> <000701ce8741$fe47deb0$fad79c10$@samsung.com>
 <51EE22DF.6090902@ti.com> <001301ce8772$522dfc50$f689f4f0$@samsung.com>
 <5231607C.10702@ti.com> <003501ceaf87$cda45db0$68ed1910$%han@samsung.com>
 <20130912093018.GA2124@pratyush-vbox> <52318CCC.4040604@ti.com>
In-reply-to: <52318CCC.4040604@ti.com>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Thu, 12 Sep 2013 19:25:59 +0900
Message-id: <000701ceafa2$792d7cb0$6b887610$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vnJpfAh61gdBCSsqRPVzYB7LbnwABbHuA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t8zI91t0wyDDH7/0rD4O+kYu8WSpgyL
	l4c0LeYfOcdqcXnhJVaL3gVX2SwuPO1hs7i8aw6bxdl5x9ksZpzfx2SxceovRov2S8oWP3fN
	Y7FoPPqA1aL1yQNGB36P378mMXrsnHWX3WPBplKP7wvns3v0bVnF6PH0x15mj+M3tjN5fN4k
	F8ARxWWTkpqTWZZapG+XwJXx5/dq1oJJnBX39i9naWBcyt7FyMkhIWAiMX3RYVYIW0ziwr31
	bF2MXBxCAssYJVZsa2SGKbrw8BBUYjqjxNYrm5khnF+MEi8b5jOBVLEJqEl8+XIYbKyIQITE
	ywuL2UGKmAWOMEvsffCGFaLjNpPE7tlLwOZyAnXMPHUYrFtYIFFi7usPYHEWAVWJpu2zgBo4
	OHgFbCWevgcr4RUQlPgx+R4LiM0soCWxfudxJghbXmLzmrfMIOUSAuoSj/7qQtxgJHGu8RUj
	RImIxL4X7xhBTpAQ2MMhseLIRVaIVQIS3yYfYoHolZXYdADqY0mJgytusExglJiFZPMsJJtn
	Idk8C8mKBYwsqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzFC0kTvDsbbB6wPMSYDrZ/ILCWa
	nA9MM3kl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YDQ0KnBm5lSKuKD26NY0zQpulsk/c7Yc+FaicoPx6u2Lp5IzCln2iOX15l5u4QhY5G/eYxr4
	jq/Am3OjfGLqu38f9YzO7T6qdTFl8lbW2Ikm4V8/HF7TFXU1Zpqn9ZFC7/KdM8VV9n08aMSk
	LzHF3GuClR7/Lbv7hqrrbtwTtDUWj8s8K7ForRJLcUaioRZzUXEiANANUeApAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsVy+t9jQd1t0wyDDBpnKFv8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLn7vm
	sVg0Hn3AatH65AGjA7/H71+TGD12zrrL7rFgU6nH94Xz2T36tqxi9Hj6Yy+zx/Eb25k8Pm+S
	C+CIamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6
	XUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8ef3ataCSZwV9/YvZ2lg
	XMrexcjJISFgInHh4SE2CFtM4sK99UA2F4eQwHRGia1XNjNDOL8YJV42zGcCqWITUJP48uUw
	WLeIQITEywuL2UGKmAWOMEvsffCGFaLjNpPE7tlLmEGqOIE6Zp46DNYtLJAoMff1B7A4i4Cq
	RNP2WUANHBy8ArYST9+DlfAKCEr8mHyPBcRmFtCSWL/zOBOELS+xec1bZpByCQF1iUd/dSFu
	MJI41/iKEaJERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWle
	ul5yfu4mRnASeia1g3Flg8UhRgEORiUe3o5ZBkFCrIllxZW5hxglOJiVRHg/TzQMEuJNSays
	Si3Kjy8qzUktPsSYDPTnRGYp0eR8YILMK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJ
	anZqakFqEcwWJg5OqQbGaTwRlRO4FmlKT2Wu/3ztHs+DLnnZ4mzv98tyNj3N9c/Kvnzf4h1L
	WnuKbqeodvZU5W2bGZ+v5JB9NnmLXrfxo6Sj2aWH956ZcPmmVYPa8Zmv2q2CNPtj7O3fJ/z6
	Wr0iYo318bQDM2VubE39e13rXpl+yr0P8/bZJB/6qNvqu+nGjPO7N39gUGIpzkg01GIuKk4E
	AHUqY/+GAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 12, 2013 6:44 PM, Kishon Vijay Abraham I wrote:
> On Thursday 12 September 2013 03:00 PM, Pratyush Anand wrote:
> >
> > From this conversation, It seems that you
> > have tested this driver and it works fine without inbound translation
> > function. I am sure that you would have tested a PCIe card with DMA
> > capability such as PCIe2USB or PCIe2Ethernet. Since it worked, it
> > means that by default your controller is supporting one to one mapping
> > in case of inbound transaction even when address translation is enabled.
> 
> btw, I'm testing Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller.
> 
> when I do ifconfig eth0 up, I get *r8169 0000:01:00.0 eth0: link up.*
> But I dont receive any packets and ping also fails and the tx and rx packet
> count is also 0. Could it be related to inbound translation?
> 

Hi Kishon,

I have tested Ethernet controller: Intel Corporation 82574L PCI Express
Gigabit Ethernet controller.

Without inbound translation, it works properly with both legacy interrupt
mode and MSI mode.

Best regards,
Jingoo Han


