Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaAGDb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:31:58 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36115 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708AbaAGDb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:31:56 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-b1-52cb75236554
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tanmay Inamdar'" <tinamdar@apm.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Catalin Marinas'" <catalin.marinas@arm.com>,
        "'Rob Landley'" <rob@landley.net>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'patches'" <patches@apm.com>, "'Jon Masters'" <jcm@redhat.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
 <1387785725-24262-2-git-send-email-tinamdar@apm.com>
 <007401cf0a81$51429250$f3c7b6f0$%han@samsung.com>
 <CACoXjcmqUixctokJ9COLWAsaDTUyVKk9vTAbW1hUhUdcgaj-kg@mail.gmail.com>
In-reply-to: <CACoXjcmqUixctokJ9COLWAsaDTUyVKk9vTAbW1hUhUdcgaj-kg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] pci: APM X-Gene PCIe controller driver
Date: Tue, 07 Jan 2014 12:31:46 +0900
Message-id: <001101cf0b58$fe73e730$fb5bb590$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8LUn0J8fDK+KL+T6Wve9z0gkVLUgABnN1w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0hTYRjHez1nZ2eCdJqXXsWyFJMENe9vV6SiDgUR2ocUyuY8bKbOsTmJ
	vuQlysRSp6YOMy9rhnnJaeAdXaGQV5SGgRloFxepNW3O1TTnMdjXvv14nv+fHw88JMYf4HiQ
	SZJ0RiYRpHgTjvjwxpfQAB/FcPSRrnEvZFUOcpE6W4yWNfkAGXSH0dM3YxzU/6cDIGVTPYam
	aiY5aG06HGnn9RxUc0+No6muSgKNVg0RqLXUAlDOiIlA9yd9ULOhDEfrXVU4+mo04lHO9M8W
	I6AbqxoB/duiBHSn6gOXrtYq6G8vKjj0jL6HoNvUd+i1joeAXu57R9CP2hsA/dnci9Er2v2X
	neIcTyQyKUkZjCzo1A1HsaHczJEuON8a6n7skAk2d+cBHgmpMFjak89h2Q1OzLYQecCR5FMa
	AF+OZRP/Qus9esAuagH8rlneSVkAtBhMwJYiqENwdfU1Nw+QpAvlB7tLPG0ZjLLicL3aymUL
	RgAXcze2CzwqBmrL328rnKkz8IHy7TbjlC98kl3kYGMn6iRsqi/AWN4DzcWzuI0xyh+2dA45
	sOwF2xoXMZsYbonnrAG2sQsVAnO653ciLrBvYWn7AkiZSWjUtOGsi4KmYh3OdvdBbT/GXuwO
	B55P44UAquzMKjuzys6sslNUA7wBuDJSoVSeIJKFB8oFqXKFRBQoTEvVAvZ9ijrAx/7jOiDc
	0hdhHq7CtK33kqTHB4dGhKDwsPDQkMijEf839t7rJJpLiOZTIkE6k8wwUkYWL1OkMHIdcCB5
	HplAhv1w0TfXXboapKoM2xI/y1mbICTpta25m7tidePTDxZ7zx1IHL247JoqLBD7Rf46Jooy
	JQ12gUK+OE5wO/bKaTdV7qfV6+0lGzEzN31WJkqXykTuVQvecweJ5BhfSIyq7yJPaOms8Dmb
	kTUyzIuMbjdmnNdnWcG1C351r7xxuVgQ7I/J5IK//agPMVQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsVy+t9jAV3l0tNBBl+WSVr8nXSM3WJJU4bF
	+2U9jBYvD2lazD9yjtXiwJ8djBaT1i5ntri88BKrxfcbphabHl9jtVjYtoTF4vKuOWwWZ+cd
	Z7PYOPUXo0XzmW9sFu2XlC3WvZzOYvFz1zwWi+efPrE4CHt8XP+J0WPNvDWMHr9/TWL02Dnr
	LrvHgk2lHq9Wz2T1uHNtD5vH5iX1Ht939DJ6vN93lc2jb8sqRo+nP/Yye3zeJBfAG9XAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9KWSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePljB+sBS+EK47vnsbUwPifv4uRk0NC
	wETi555rjBC2mMSFe+vZuhi5OIQEFjFKvFn2Hsr5xSjx6+U3sCo2ATWJL18Os3cxcnCICKhL
	7J4iA1LDLPCXReLngr/sEA2fGCXedvwDa+AUCJbYNOMmG4gtLOAs0TnpFJjNIqAqMbdpIhOI
	zStgK7F2eT8zhC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lBFksALX70VxckLCJgJNG8+zFU
	iYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg
	1PZMagfjygaLQ4wCHIxKPLwv9p4KEmJNLCuuzD3EKMHBrCTCq5lyOkiINyWxsiq1KD++qDQn
	tfgQYzLQoxOZpUST84FpN68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUw
	W5g4OKWAqaxuQt591TNTDy22EGea3HrK8G26doLlZkE1s7V8mlOXZ0r2d1hFs6Ssu/BuYt48
	nl01Z+fPExVbukSeP6o13uZwkLlo8fvCbfznY1b0JcYzbXv/4p9UqOXWphodp/zTyTMfXX9x
	I6lzdT/PYuafieLBTdsem2kvSN9wTvZw6a+MrcLuQQe3KbEUZyQaajEXFScCAP76CEOxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 07, 2014 11:45 AM, Tanmay Inamdar wrote:
> On Sun, Jan 5, 2014 at 5:47 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> > On Monday, December 23, 2013 5:02 PM, Tanmay Inamdar wrote:
> >>
> >> This patch adds the AppliedMicro X-gene SOC PCIe controller driver.
> >> APM X-Gene PCIe controller supports maximum upto 8 lanes and
> >> GEN3 speed. X-Gene has maximum 5 PCIe ports supported.
> >
> > (+cc Jason Gunthorpe, Arnd Bergmann)
> >
> > Hi Tanmay Inamdar,
> >
> > I added some minor comments. :-)
> >
> >>
> >> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> >> ---
> >>  drivers/pci/host/Kconfig      |    5 +
> >>  drivers/pci/host/Makefile     |    1 +
> >>  drivers/pci/host/pcie-xgene.c | 1017 +++++++++++++++++++++++++++++++++++++++++
> >
> > Would you change the file name to 'pci-xgene.c'?
> > Now, all PCI host drivers are using the prefix 'pci-', not 'pcie-'.
> 
> I guess designware is an exception. There is
> "drivers/pci/host/pcie-designware.c"

(+cc Thierry Reding, Pratyush Anand, Mohit KUMAR)

Now, the current naming rule is "PCI-" prefix as below.

  - Samsung Exynos: "pci"-exynos.c
  - Freescale i.MX6: "pci"-imx6.c
  - Marvell: pci-mvebu.c
  - Nvidia Tegra: pci-tegra.c
  - Renesas R-Car: pci-rcar-gen2.c

According to the Thierry Reding's comment,
"I think we should keep these sorted alphabetically. Also Tegra and
Marvell are PCIe controllers but they still use the pci- prefix instead
of pcie-. Perhaps it'd be good to keep consistency here? I initially
chose pci- because from a software point of view it doesn't matter all
that much whether it's PCI or PCIe and because the drivers are part of
the PCI subsystem. However if Exynos now uses the pcie- prefix it makes
it look like Tegra and Marvell are plain old PCI."
(https://groups.google.com/forum/#!msg/linux.kernel/qtimJoNSc3w/_1aayHaG54YJ)

However, "pcie-designware.c" is common layer driver for other
SoC PCI host drivers that use Synopsys Designware PCI IP.
Thus, currently it is shared by other SoC PCI host drivers
such as pci-exynos.c, and pci-imx6.c. Also, ST PCI driver will
use pcie-designware.c as common layer.

Originally, "pci"-designware.c was used. However, Pratyush Anand
suggested "pci"-designware.c can be renamed to "pcie"-designware.c,
because Synopsys PCI IP and Synopsys PCI Express IP are different.
So, currently "pcie"-designware.c is used.

So, if there is no special reason, "pci-" prefix can be used.
Thank you.

Best regards,
Jingoo Han

