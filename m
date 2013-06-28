Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3F1D1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 23:27:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13276 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3F1D1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 23:27:17 -0400
X-AuditID: cbfee68e-b7f276d000002279-cf-51cd029384e8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "'Rob Landley'" <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        "'Benoit Cousson'" <benoit.cousson@linaro.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "'Cesar Eduardo Barros'" <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        "'Rajendra Nayak'" <rnayak@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, Balaji T K <balajitk@ti.com>,
        "'George Cherian'" <george.cherian@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v9 1/8] drivers: phy: add generic PHY framework
Date: Fri, 28 Jun 2013 12:27:15 +0900
Message-id: <000d01ce73af$62a95a60$27fc0f20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5zq2w+bxe+CzysT7mzOBIBp+zYQA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0hTYRjHe885O5uWeTbT3kS7LJIUM523V4wIKnjpQ2QFiZS6tpOKt7V5
	AyGN7CZmtVXqNFGbl0xdmZWWujk1QzM1LymaEqHmHSqlEivnDPzatz/P//9/fs+Hh0cKxjm2
	vLCoGFYeJY4Q0uZU2+8x0R4V0e7n2jHkjXK0ZTRaUr7moruqFzRqGElCWV8HaKTuO44mDI4o
	pyOFQvrsTxzU2lDMQZNvn9Do0gMtjbrz33NQ52gajSo/93FQ/hUNhbpf5tAoW3OTQgVFl0k0
	2G2BapsbuUh34zGBxm7WAtRYoidQxUQGhRqnr3LQVHoZiUYrNCTS9Rw5YI9TLqXRePGXEuCF
	eSWF8771cHHTYCaJqx4OEHjyURYHD/XV0vhN5iKFdffLuPipJgl3ZOYDPFffS+P0qlKAf044
	45b+F8QxfoD5PikbERbHyvfuDzYPzX2+Q7ZombBQGJwMCtenAjMeZDzgt2u3OCZtAzuHtXQq
	MOcJmCIAR8ffcP+FMupeAZNRAGBz/UfCaAiYXwAqaw4YNc04wO/fG1cKmxhnmN+mJY0Fkknl
	wYutKspoWDEHYUmdkjRqitkF01rHlws8ngXjA6fvKIxjC4YPf6iGV+Ik4wS1NS2ESW+DT8tm
	SNNB22F1+xQwsVzgrG5pNbMJ1n+ZXTkUMjozON9QyzWxGLigMlBGFmTsYaV+dc8W2FDST90C
	Nuo1aPUatHoNWr0GkQeoUmDNyiQyxdkQuchFIY5UxEaFuEiiIyuB6cnSq8GA3tcAJMv426St
	tSR6+QmjYoLc3L1EyNPD013k7eP1f2PhZguHFF8/ARMijmHDWVbGyoPksRGswgAInpltMlAq
	t04pXd0vbDiMU+02yqRJlkHDuUPUdfroB70dkegY4csPK4/f5unb9c6RW5578o9/sYt9eE18
	cFPcs4RAoeGeZqhlXlpqX3VIoY2bleyuthKyJybbzqd7n47ZGWCdYPA/l9jjX3lm3YI0sEjU
	2+U9t26aPkULsnuk/BF+/IyQUoSK3ZxIuUL8F1usw8N6AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsVy+t9jAd3JTGcDDc60GljMWb+GzeLvpGPs
	FlMnb2ezOHi/3mLmp5tsFrOuBVm8PKRpMed8C4vFgdkPWS1OHVzOavHqzEY2i+bF69ksLi+8
	xGpx4WkPm8Wmx9dYLRa2LWGxuLxrDpvF7CX9LBaLlrUyW9y+zGux5+hhdov9vRuYLJ7172G0
	OLziAJPFupfTWSwOv2lntXjdt4bZ4um6JcwW+694Och6tDT3sHn8/jWJ0ePb10ksHgs+X2H3
	OHJ7BrPHlpU3mTxerZ7J6nHn2h42jxMzfrN47J+7ht1j85J6j/MzFjJ6vN93lc2jb8sqRo+f
	L3U8jt/YzhQgGNXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDDCYlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8a8bYoFv/kr
	vi1NaGBcyt3FyMkhIWAiMX3vbkYIW0ziwr31bF2MXBxCAosYJY7uu8sEkhAS+MUoMWmnA4jN
	JqAm8eXLYXYQW0RAR2Lh6fXMIA3MAl0cEo2nJrOAJIQFnCVW7J3EDGKzCKhK9Jx6DtTAwcEr
	YCnxZkoxSJhXQFDix+R7YOXMAloS63ceZ4Kw5SU2r3nLDHGQgsSOs68ZIXbpSbzb/xeqRkRi
	34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwmnwm
	tYNxZYPFIUYBDkYlHt7GxDOBQqyJZcWVuYcYJTiYlUR47ywACvGmJFZWpRblxxeV5qQWH2JM
	Bnp0IrOUaHI+MIXnlcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwen
	VAPjNssocTalN9/OMS/zKFHu9ixfV2dQ5xWmlbhM8vqsGynKgVp8y6bcmrn7pcCagD13t2/Q
	NS7K2nxB78VdC97MpwKvf+xYZmRXw1u6U2w21z91gWlT/YtlLYW2nkpPNdYU+zz5SsVTlX77
	gDbHo66R1dsfy9vLhrD+rZmt1md4OWzVm5sCzF+UWIozEg21mIuKEwGaJn3L1wMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 17:17:29 +0530, Kishon Vijay Abraham Iwrote:
> The PHY framework provides a set of APIs for the PHY drivers to
> create/destroy a PHY and APIs for the PHY users to obtain a reference to the
> PHY with or without using phandle. For dt-boot, the PHY drivers should
> also register *PHY provider* with the framework.
>
> PHY drivers should create the PHY by passing id and ops like init, exit,
> power_on and power_off. This framework is also pm runtime enabled.
>
> The documentation for the generic PHY framework is added in
> Documentation/phy.txt and the documentation for dt binding can be found at
> Documentation/devicetree/bindings/phy/phy-bindings.txt
>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Tested-by: Jingoo Han <jg1.han@samsung.com>

It looks great to me!

I tested this General PHY framework with Exynos5250 eDP.
It works properly.
I will share the patch 'Generic PHY driver for the Exynos SoC DP PHY', soon.
Thanks.

Best regards,
Jingoo Han

> ---
>  .../devicetree/bindings/phy/phy-bindings.txt       |   66 +++
>  Documentation/phy.txt                              |  129 +++++
>  MAINTAINERS                                        |    7 +
>  drivers/Kconfig                                    |    2 +
>  drivers/Makefile                                   |    2 +
>  drivers/phy/Kconfig                                |   13 +
>  drivers/phy/Makefile                               |    5 +
>  drivers/phy/phy-core.c                             |  544 ++++++++++++++++++++
>  include/linux/phy/phy.h                            |  344 +++++++++++++
>  9 files changed, 1112 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/phy-bindings.txt
>  create mode 100644 Documentation/phy.txt
>  create mode 100644 drivers/phy/Kconfig
>  create mode 100644 drivers/phy/Makefile
>  create mode 100644 drivers/phy/phy-core.c
>  create mode 100644 include/linux/phy/phy.h

