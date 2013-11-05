Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab3KEMD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:03:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49932 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3KEMDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:03:22 -0500
X-AuditID: cbfee691-b7f866d000001b8c-92-5278de88822d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kamil Debski'" <k.debski@samsung.com>,
        "'Vivek Gautam'" <gautamvivek1987@gmail.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>, "'Felipe Balbi'" <balbi@ti.com>,
        "'Julius Werner'" <jwerner@chromium.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
 <1383205544-32244-2-git-send-email-gautam.vivek@samsung.com>
 <527744B2.4090303@ti.com> <030d01ced946$d6e23490$84a69db0$%debski@samsung.com>
 <52779D28.9000905@ti.com>
 <CAFp+6iH7vQ-OtMFL4pyr4tFDRchH4oh1Z0753WNgrHiUzj+kzw@mail.gmail.com>
 <00fe01ceda0a$941957a0$bc4c06e0$%debski@samsung.com>
 <000001ceda17$f41c2030$dc546090$%han@samsung.com>
In-reply-to: <000001ceda17$f41c2030$dc546090$%han@samsung.com>
Subject: Re: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
Date: Tue, 05 Nov 2013 21:03:19 +0900
Message-id: <000101ceda1f$04ca6f20$0e5f4d60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7Z94C3HLaVZLM8ToO0AWrZx8HMmwACIfqgAAV4W7AAAfPMQA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t8zQ92OexVBBnNeClkcvF9vMf/IOVaL
	tisH2S3eft/CbtG8eD2bxeWFl1gtOg49ZrL48foCm0XvgqtsFhee9rBZbHp8jdViYdsSFovL
	u+awWcw4v4/JYtGyVmaLw2/aWS3Wz3jN4iDoMbvhIovHzll32T32z13D7rF5Sb1H35ZVjB7H
	b2xn8vi8SS6APYrLJiU1J7MstUjfLoEr4+wc+4K9khU7N59mamD8LNTFyMkhIWAiMf3genYI
	W0ziwr31bCC2kMAyRolVnXIwNf3X9zB2MXIBxaczSqx9twHK+cUoMWXnOVaQKjYBNYkvXw6z
	gyREBJoZJa4fPMUK4jALzGWRuPVmAzNEyzJmiZ7jNxhBWjgF7CTWfG0FWygs4CLRuP0SUJyD
	g0VAVeL4RHmQMK+ArUTLksXMELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGUGaZUQUJd49FcX
	JCwi4CSx+V0/K0SJiMS+F+/ArpYQOMMhcWVtH1iCRUBA4tvkQywQvbISmw4wQ7wsKXFwxQ2W
	CYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRkjKmLiD8f4B
	60OMyUDrJzJLiSbnA1NOXkm8obGZkYWpiamxkbmlGWnCSuK86Y+SgoQE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUw2jot22PYwKCX+nOBzoNts+fNVPnU7nDY+kAM60OtDNcNH/WOM11bHvbP
	QuhoVIrRa7MtGfYXjKpldk36y8Gbx/F1I5fPPCNjSYfbsVt3hgY82RNiE8T22t63wj5uTvNF
	5rA1HW+U7pW9fCfIGOHt/tGsVm+7bmPhovyMbTtvCnhXr46La9VUYinOSDTUYi4qTgQARfrK
	Ti8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsVy+t9jQd2OexVBBm/+8lgcvF9vMf/IOVaL
	tisH2S3eft/CbtG8eD2bxeWFl1gtOg49ZrL48foCm0XvgqtsFhee9rBZbHp8jdViYdsSFovL
	u+awWcw4v4/JYtGyVmaLw2/aWS3Wz3jN4iDoMbvhIovHzll32T32z13D7rF5Sb1H35ZVjB7H
	b2xn8vi8SS6APaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6AMlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bZOfYFeyUr
	dm4+zdTA+Fmoi5GTQ0LARKL/+h5GCFtM4sK99WxdjFwcQgLTGSXWvtvACOH8YpSYsvMcK0gV
	m4CaxJcvh9lBEiICzYwS1w+eYgVxmAXmskjcerOBGaJlGbNEz/EbYIM5Bewk1nxtZQOxhQVc
	JBq3XwKKc3CwCKhKHJ8oDxLmFbCVaFmymBnCFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCCt
	EgLqEo/+6oKERQScJDa/62eFKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCc
	lJ5rqFecmFtcmpeul5yfu4kRnJKeSe1gXNlgcYhRgINRiYf3wdnyICHWxLLiytxDjBIczEoi
	vG1HKoKEeFMSK6tSi/Lji0pzUosPMSYD/TmRWUo0OR+YLvNK4g2NTcyMLI3MLIxMzM1JE1YS
	5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgdHsyYTDaxr59+wTm3Aqy/sty+7ssD1JuewfpF51
	8lbYi5o0iybWT5vncT/j4svT/k8u5kkFHS42Zp8QIPnmod3ef8GrJTxPPdALnJ0+0d2YP2zr
	+0btVT3ve7NnNJydXvjHxHnyLud07svP4i9NEve3n234TUB2y9av/38IOh0yLCzbeEJs0SIl
	luKMREMt5qLiRADFPTG/jQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 05, 2013 8:13 PM, Jingoo Han wrote:
> On Tuesday, November 05, 2013 6:37 PM, Kamil Debski wrote:
> > On Tuesday, November 05, 2013 8:20 AM, Vivek Gautam wrote:
> > > On Mon, Nov 4, 2013 at 6:42 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> > > > On Monday 04 November 2013 03:45 PM, Kamil Debski wrote:
> > > >> On Monday, November 04, 2013 7:55 AM, Kishon Vijay Abraham I wrote:
> > > >>> On Thursday 31 October 2013 01:15 PM, Vivek Gautam wrote:
> > > >>>>
> > > >>>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
> > > >>>> The new driver uses the generic PHY framework and will interact
> > > >>>> with
> > > >>>> DWC3 controller present on Exynos5 series of SoCs.
> > > >>>
> > > >>>
> > > >>> In Exynos, you have a single IP that supports both USB3 and USB2
> > > PHY
> > > >>> right? I think that needs to be mentioned here.
> > > >>
> > > >>
> > > >> As far as I know the IP is different.
> > > >
> > > >
> > > > Ok. Sometime back Vivek was mentioning about a single IP for both
> > > USB3
> > > > and USB2. Thought it should be this driver. Anyway thanks for the
> > > clarification.
> > >
> > > Right Kishon, I had mentioned that Exynos5's dwc3 controller have a
> > > single IP for USB2 and USB3 phy.
> > > From what i see, on exynos5 systems the dwc3 controller uses a combo of
> > > usb 2 (utmi+) and usb 3 (pipe 3) phy (with base address starting
> > > 0x12100000).
> > >
> > > Kamil, Tomasz,
> > >
> > > Please correct me if i am wrong.
> >
> > I have the Exynos 5250 documentation and I found two phy register ranges:
> > 1) USB 2.0 PHY having the base address of 0x1213 0000
> > 	Chapter 33. USB 2.0 Host Controller
> > 	Subchapter 33.5.2 Phy Control Register p. 1696
> > 	First register's description is
> > 	"USB2.0 phy control register"
> > 2) USB 3.0 PHY (I guess) with the base address 0x1210 0000
> > 	Chapter 35. USB 3.0 DRD Controller
> > 	Subchapter 35.4.6 PHY Control Register p. 1872
> >
> > Jingoo, could you comment on the above? You may know more than we do :)
> 
> Hi Kamil,
> 
> Thank you for trusting me. :-)
> I just asked my validation engineer about 5250 USB PHY.
> As I know, she has the best knowledge about Samsung SoC USB hardware.
> She said that there are 2 PHY controllers such as USB 2.0 PHY, USB 3.0 PHY.
> 
>   1) USB2.0 PHY: USB2.0 HOST, USB2.0 Device
>   2) USB3.0 PHY: USB3.0 DRD (3.0 HOST & 3.0 Device)
> 
> > In addition, I have a question to you Vivek - does your USB 3.0
> > PHY support both host and device?
> 
> According to her, USB3.0 PHY can support both 3.0 Host and 3.0 Device.
> Thank you.

In addition to this,

Vivek's comment is also right. :-)
A few minutes ago, I asked one of my USB S/W engineers.

USB3.0 PHY consists of two blocks such as 3.0 block and 2.0 block.
This USB3.0 PHY can support UTMI+ and PIPE3 interface for 3.0 block
and 2.0 block, respectively.

Conclusion:

   1) USB2.0 PHY: USB2.0 HOST, USB2.0 Device
                       Base address: 0x1213 0000

   2) USB3.0 PHY: USB3.0 DRD (3.0 HOST & 3.0 Device)
                       Base address: 0x1210 0000
                       2.0 block(UTMI+) & 3.0 block(PIPE3)


Best regards,
Jingoo Han

