Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaGQC7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 22:59:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36979 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaGQC66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 22:58:58 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-76-53c73bf014aa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, mohit.kumar@st.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1405349705-31400-1-git-send-email-kishon@ti.com>
In-reply-to: <1405349705-31400-1-git-send-email-kishon@ti.com>
Subject: Re: [PATCH v2 0/4] dra7: Add PCIe support
Date: Thu, 17 Jul 2014 11:58:55 +0900
Message-id: <009001cfa16b$0c558ea0$2500abe0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+fc6jaSCSfrxqlRd+Y0jGvhRQk4AB9Z4Ew
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zI90P1seDDR7+YLJY0pRh8fKQpsX8
	I+dYLQ782cFocXnhJVaLC0972CwWti1hsbi8aw6bxdl5x9ksNk79xejA5bFgU6nHnWt72Dz6
	tqxi9Hj6Yy+zx/Eb25k8Pm+SC2CL4rJJSc3JLEst0rdL4MrYvmQZU0EXb8XUi99ZGhhfcXYx
	cnBICJhITNuc08XICWSKSVy4t56ti5GLQ0hgGaNE89ql7BAJE4k33XvZIRLTGSWWtkxlgXB+
	M0psfjKTBaSKTUBN4suXw2AdIgI6EgtPr2cGKWIWuMcoseDCPzaQhJCArcSraT/YQVZzCthJ
	bOtLBQkLCxhJLDu4gAkkzCKgKtH4KxTE5AWqXnnHDaSCV0BQ4sfke2CbmAW0JNbvPM4EYctL
	bF7zlhniF3WJR391IQ4wkjj59BFUuYjEvhfvGEGOkRDo5JCYtOUpM0iCRUBA4tvkQywQvbIS
	mw4wQ7wrKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kZFecWJucWleul5y
	fu4mRkhs9+1gvHnA+hBjMtD6icxSosn5wNSQVxJvaGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC
	6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYRU6FMh7cvU5ErOr9sdWT5OY8L7Z663X8+8Q1HpOq
	tvJdP/VS7mj0OZ3WwCjOtpSmhtTW27kK1hsNukrqgsN9jn/K4llT/krspkTwplVlZhYvnpzV
	v/jJ8vEkpXm+7hNr51z4ybYyc9Xhj6c3+XHfW1HN7rOiSnffwaCpk3n4DmcbfGdad2vDJiWW
	4oxEQy3mouJEALw2dPMDAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQd331seDDVYtsbZY0pRh8fKQpsX8
	I+dYLQ782cFocXnhJVaLC0972CwWti1hsbi8aw6bxdl5x9ksNk79xejA5bFgU6nHnWt72Dz6
	tqxi9Hj6Yy+zx/Eb25k8Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
	MFdSyEvMTbVVcvEJ0HXLzAE6TEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpI
	WMeYsX3JMqaCLt6KqRe/szQwvuLsYuTkkBAwkXjTvZcdwhaTuHBvPVsXIxeHkMB0RomlLVNZ
	IJzfjBKbn8xkAaliE1CT+PLlMFiHiICOxMLT65lBipgF7jFKLLjwjw0kISRgK/Fq2g+gIg4O
	TgE7iW19qSBhYQEjiWUHFzCBhFkEVCUaf4WCmLxA1SvvuIFU8AoISvyYfA9sE7OAlsT6nceZ
	IGx5ic1r3jKDlEsIqEs8+qsLcYCRxMmnj6DKRST2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlW
	MYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSnjmdSOxhXNlgcYhTgYFTi4U1oPRYsxJpYVlyZ
	e4hRgoNZSYTXlel4sBBvSmJlVWpRfnxRaU5q8SFGU6A3JzJLiSbnA9NaXkm8obGJmZGlkZmF
	kYm5uZI474FW60AhgfTEktTs1NSC1CKYPiYOTqkGxrMf+XNTy91LOb74zX/ucGjzv2if26ba
	m9aun+n0QlCv+ZvKNtXDK+u/T0ix4p7q5M/g3xZ69drtj8/dNi1YGXD4f92SmUrHvFbc0tt6
	JKjq9f/a5eUfM5c0lt1b7beqTflH1tHvO7Zu+5Cflvn948Hf56auabTq0dk0z/2+YuOsnPmO
	Gyb8efhAiaU4I9FQi7moOBEAed8ZBDMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 14, 2014 11:55 PM, Kishon Vijay Abraham I wrote:
> 
> Changes from v1:
> * fixed dw_pcie_prog_viewport_io_outbound() to use untranslated address
> * split dra7xx patch into driver part and documentation part
> 
> [1] is split into separate series in order for individual subsystem
> Maintainers to pick up the patches. This series handles the PCIe
> support for DRA7.
> 
> Rebased to pci -next.
> 
> [1] -> https://lkml.org/lkml/2014/5/29/258
> 
> Kishon Vijay Abraham I (4):
>   PCI: designware: Configuration space should be specified in 'reg'
>   PCI: designware: use untranslated address while programming ATU
>   Documentation: pci: ti: Add dt binding documentation for PCIe in
>     DRA7xx
>   PCI: host: pcie-dra7xx: add support for pcie-dra7xx controller

Kishon,

Actually, I have no objections to these patches.
Then, how about adding maintainer entry for pci-dra7xx.c
to MAINTAINERS file? It would be good. :-)

Best regards,
Jingoo Han

> 
>  .../devicetree/bindings/pci/designware-pcie.txt    |    4 +
>  Documentation/devicetree/bindings/pci/ti-pci.txt   |   59 +++
>  drivers/pci/host/Kconfig                           |   10 +
>  drivers/pci/host/Makefile                          |    1 +
>  drivers/pci/host/pci-dra7xx.c                      |  458 ++++++++++++++++++++
>  drivers/pci/host/pcie-designware.c                 |   72 ++-
>  drivers/pci/host/pcie-designware.h                 |    4 +
>  7 files changed, 592 insertions(+), 16 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pci/ti-pci.txt
>  create mode 100644 drivers/pci/host/pci-dra7xx.c
> 
> --
> 1.7.9.5

