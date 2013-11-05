Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3KELMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:12:50 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37681 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3KELMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:12:47 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-44-5278d2adb2ff
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
In-reply-to: <00fe01ceda0a$941957a0$bc4c06e0$%debski@samsung.com>
Subject: Re: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
Date: Tue, 05 Nov 2013 20:12:45 +0900
Message-id: <000001ceda17$f41c2030$dc546090$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7Z94C3HLaVZLM8ToO0AWrZx8HMmwACIfqgAAV4W7A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t8zI921lyqCDH53GVkcvF9vMf/IOVaL
	tisH2S3eft/CbtG8eD2bxeWFl1gtOg49ZrL48foCm0XvgqtsFhee9rBZbHp8jdViYdsSFovL
	u+awWcw4v4/JYtGyVmaLw2/aWS3Wz3jN4iDoMbvhIovHzll32T32z13D7rF5Sb1H35ZVjB7H
	b2xn8vi8SS6APYrLJiU1J7MstUjfLoErY3HPU6aCc8IV3xtXMDYwNvN3MXJwSAiYSCy7m97F
	yAlkiklcuLeeDcQWEljGKDHhhAZE3ERi6tNdTF2MXEDx6YwSf5ftZoRwfjFKTFv/kxmkik1A
	TeLLl8PsIAkRgWZGiesHT7GCOMwCc1kkbr3ZwAzR8olJ4sSTdlaQFk4BR4mfv78wgdjCAi4S
	jdsvMYLYLAKqEo07uhhB7uMVsJV4sikUJMwrICjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmSHe
	UZd49FcXJCwiYCXx+PAvqHIRiX0v3oFdLSFwhkPi0KutbBCrBCS+TT7EAtErK7HpADPEy5IS
	B1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmKEpIy+
	HYw3D1gfYkwGWj+RWUo0OR+YcvJK4g2NzYwsTE1MjY3MLc1IE1YS5130MClISCA9sSQ1OzW1
	ILUovqg0J7X4ECMTB6dUA2PWrSaXxKD2VG2bM50rz+o3TnolaCR7x+H7XckT616JeCr93rry
	9p25gSE7HJ4HpJR96w8/9d2s2+5L3wUnJ0dBx+hqza2iYpWnfJ5vD1qm7fxdV+eY353qYtHV
	SdXtO2OPCgvn/M+Q8GNJ7/19fM2VV0sup068du7VsqV7hNdpa9rc/f7TaZ4SS3FGoqEWc1Fx
	IgCKUNBwLwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsVy+t9jQd21lyqCDHb+07Y4eL/eYv6Rc6wW
	bVcOslu8/b6F3aJ58Xo2i8sLL7FadBx6zGTx4/UFNoveBVfZLC487WGz2PT4GqvFwrYlLBaX
	d81hs5hxfh+TxaJlrcwWh9+0s1qsn/GaxUHQY3bDRRaPnbPusnvsn7uG3WPzknqPvi2rGD2O
	39jO5PF5k1wAe1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKL
	T4CuW2YO0AdKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xozFPU+ZCs4J
	V3xvXMHYwNjM38XIySEhYCIx9ekuJghbTOLCvfVsXYxcHEIC0xkl/i7bzQjh/GKUmLb+JzNI
	FZuAmsSXL4fZQRIiAs2MEtcPnmIFcZgF5rJI3HqzgRmi5ROTxIkn7awgLZwCjhI/f38BWyIs
	4CLRuP0SI4jNIqAq0bijC8jm4OAVsJV4sikUJMwrICjxY/I9FhCbWUBLYv3O40wQtrzE5jVv
	mUHKJQTUJR791QUJiwhYSTw+/AuqXERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFy
	QXFSeq6hXnFibnFpXrpecn7uJkZwUnomtYNxZYPFIUYBDkYlHt4HZ8uDhFgTy4orcw8xSnAw
	K4nwth2pCBLiTUmsrEotyo8vKs1JLT7EmAz050RmKdHkfGDCzCuJNzQ2MTOyNDKzMDIxNydN
	WEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRu2XnKYGIts0NHKd6o08L10sFXMuYZq74bRh
	87fnO+xV30UesXmlaqD/a1rPBrHfrxQYJkbemCJzrfgwj4kc49p0w3s6ckdeWx06IGle69xz
	5foag7WCx6ZzVe86X3eEs8/+abPc+Ws+Lxb7sFSzPrNrub6Rt71d+SLn1oDK5LdHFDrnmfoq
	KbEUZyQaajEXFScCANbI+piOAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 05, 2013 6:37 PM, Kamil Debski wrote:
> On Tuesday, November 05, 2013 8:20 AM, Vivek Gautam wrote:
> > On Mon, Nov 4, 2013 at 6:42 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> > > On Monday 04 November 2013 03:45 PM, Kamil Debski wrote:
> > >> On Monday, November 04, 2013 7:55 AM, Kishon Vijay Abraham I wrote:
> > >>> On Thursday 31 October 2013 01:15 PM, Vivek Gautam wrote:
> > >>>>
> > >>>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
> > >>>> The new driver uses the generic PHY framework and will interact
> > >>>> with
> > >>>> DWC3 controller present on Exynos5 series of SoCs.
> > >>>
> > >>>
> > >>> In Exynos, you have a single IP that supports both USB3 and USB2
> > PHY
> > >>> right? I think that needs to be mentioned here.
> > >>
> > >>
> > >> As far as I know the IP is different.
> > >
> > >
> > > Ok. Sometime back Vivek was mentioning about a single IP for both
> > USB3
> > > and USB2. Thought it should be this driver. Anyway thanks for the
> > clarification.
> >
> > Right Kishon, I had mentioned that Exynos5's dwc3 controller have a
> > single IP for USB2 and USB3 phy.
> > From what i see, on exynos5 systems the dwc3 controller uses a combo of
> > usb 2 (utmi+) and usb 3 (pipe 3) phy (with base address starting
> > 0x12100000).
> >
> > Kamil, Tomasz,
> >
> > Please correct me if i am wrong.
> 
> I have the Exynos 5250 documentation and I found two phy register ranges:
> 1) USB 2.0 PHY having the base address of 0x1213 0000
> 	Chapter 33. USB 2.0 Host Controller
> 	Subchapter 33.5.2 Phy Control Register p. 1696
> 	First register's description is
> 	"USB2.0 phy control register"
> 2) USB 3.0 PHY (I guess) with the base address 0x1210 0000
> 	Chapter 35. USB 3.0 DRD Controller
> 	Subchapter 35.4.6 PHY Control Register p. 1872
> 
> Jingoo, could you comment on the above? You may know more than we do :)

Hi Kamil,

Thank you for trusting me. :-)
I just asked my validation engineer about 5250 USB PHY.
As I know, she has the best knowledge about Samsung SoC USB hardware.
She said that there are 2 PHY controllers such as USB 2.0 PHY, USB 3.0 PHY.

  1) USB2.0 PHY: USB2.0 HOST, USB2.0 Device
  2) USB3.0 PHY: USB3.0 DRD (3.0 HOST & 3.0 Device)

> In addition, I have a question to you Vivek - does your USB 3.0
> PHY support both host and device?

According to her, USB3.0 PHY can support both 3.0 Host and 3.0 Device.
Thank you.

Best regards,
Jingoo Han

