Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3C0B34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 21:29:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37938 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3C0B3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 21:29:54 -0400
X-AuditID: cbfee690-b7f656d0000007e3-98-51524b90fe75
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rob Herring'" <robherring2@gmail.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
 <00c301ce277b$f2790080$d76b0180$%han@samsung.com> <51521421.9020906@gmail.com>
In-reply-to: <51521421.9020906@gmail.com>
Subject: Re: [PATCH 4/6] pci: Add PCIe driver for Samsung Exynos
Date: Wed, 27 Mar 2013 10:29:51 +0900
Message-id: <005401ce2a8a$943cf780$bcb6e680$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4qaY3YqNXk3o4YRFmc6c+C1/t+cAAH4c/Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+Zoe4E76BAgw2LxS2a/29ntVjSlGFx
	YPZDVovLCy+xWny/YWrRu+Aqm8Wmx9eAQrvmsFmcnXeczWLG+X1MFt+/fWOzWNG0ldFi8cXl
	zA68HmvmrWH02DnrLrvHgk2lHpuX1Hucn7GQ0eP7jl5Gj74tqxg9Pm+SC+CI4rJJSc3JLEst
	0rdL4MpY2tLJWNDNXXF38nvWBsatHF2MnBwSAiYSjR8XMEHYYhIX7q1n62Lk4hASWMYoce7Q
	GTaYogsbbrGA2EICixglFs3OgCj6xSjx+1EzWIJNQE3iy5fD7CC2iICmxKUJ3xlBipgFPjNL
	TFm3FGpsH6NE88nzYFWcQFVL3q5kBbGFBRwkTrw4ADaJRUBV4u/BK8wgNq+ArcSx5/egbEGJ
	H5PvgdUwC2hJrN95nAnClpfYvOYtUA0H0KnqEo/+6kIcYSRxcdUSdogSEYl9L96BHSQhsJRD
	omfORahdAhLfJh9igeiVldh0gBniY0mJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuS
	C4qT0otM9IoTc4tL89L1kvNzNzFCUsKEHYz3DlgfYkwGWj+RWUo0OR+YUvJK4g2NzYwsTE1M
	jY3MLc1IE1YS51VvsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwOgjVfnkZ2nK0cUqxaLS
	nMxGu+OeO2su7OhtF/+1yNpNgS3iqM7y16FLFXje1qUuLdizT9ismGttss6F1tLE0DMee+Yp
	fZCeJyw3z8nG2G/tx7DiagM31bP7/Xr8DS+JLT06577v97/a2zJdOV6z/z6gMpGv6kPPjLkJ
	cxZVb50jZKWu7vmnTYmlOCPRUIu5qDgRAMcQcgMfAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t9jAd0J3kGBBl3rBS2a/29ntVjSlGFx
	YPZDVovLCy+xWny/YWrRu+Aqm8Wmx9eAQrvmsFmcnXeczWLG+X1MFt+/fWOzWNG0ldFi8cXl
	zA68HmvmrWH02DnrLrvHgk2lHpuX1Hucn7GQ0eP7jl5Gj74tqxg9Pm+SC+CIamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6WEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsbSlk7Ggm7vi7uT3rA2MWzm6GDk5JARMJC5s
	uMUCYYtJXLi3ng3EFhJYxCixaHZGFyMXkP2LUeL3o2awIjYBNYkvXw6zg9giApoSlyZ8ZwQp
	Yhb4zCwxZd1SNoiOPkaJ5pPnwao4gaqWvF3JCmILCzhInHhxAGwSi4CqxN+DV5hBbF4BW4lj
	z+9B2YISPybfA6thFtCSWL/zOBOELS+xec1boBoOoFPVJR791YU4wkji4qol7BAlIhL7Xrxj
	nMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYITzjOpHYwr
	GywOMQpwMCrx8M5gCAoUYk0sK67MPcQowcGsJMJr4wgU4k1JrKxKLcqPLyrNSS0+xJgM9OhE
	ZinR5HxgMswriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBkYP
	hujM37eXTqhbeGJC9UPHZ0b/f25cIH1WUTrixYRd7hyVvEfsqt02pu4LEnnP5evon7ag3O7H
	zuT+9Nv5Dd/Ef/D/4XJ07hWTXy+/6mHBo6Pvnx99W2Gzqo5V8dzt/CXeDCwmYbtud9h6iTd3
	Tdriqfj72Qs3FtbDOZoL5PcvnXY8suqNZY0SS3FGoqEWc1FxIgB/vDVhfAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 27, 2013 6:33 AM, Rob Herring wrote:
> 
> On 03/22/2013 11:07 PM, Jingoo Han wrote:
> > Exynos5440 has a PCIe controller which can be used as Root Complex.
> > This driver supports a PCIe controller as Root Complex mode.
> >
> > Signed-off-by: Surendranath Gurivireddy Balla <suren.reddy@samsung.com>
> > Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  .../devicetree/bindings/pci/exynos-pcie.txt        |   56 +
> >  drivers/pci/host/Kconfig                           |    5 +
> >  drivers/pci/host/Makefile                          |    1 +
> >  drivers/pci/host/pci-exynos.c                      | 1139 ++++++++++++++++++++
> >  4 files changed, 1201 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/pci/exynos-pcie.txt
> >  create mode 100644 drivers/pci/host/Makefile
> >  create mode 100644 drivers/pci/host/pci-exynos.c
> 
> [...]
> 
> > +
> > +/* synopsis specific PCIE configuration registers*/
> 
> If this is a standard IP block, then the driver naming should reflect
> that. I suspect there are several others with the same IP block.

Sorry, I don't think so.
Only core block is a standard IP block, other parts are Exynos-specific.
So, it is hard to share with other PCIe IPs using synopsis core.

Best regards,
Jingoo Han

> 
> Rob

