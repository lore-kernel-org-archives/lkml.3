Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab3K1F3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 00:29:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19403 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3K1F3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 00:29:19 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-09-5296d4adf463
From: Jingoo Han <jg1.han@samsung.com>
To: "'Joe Perches'" <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andy Whitcroft'" <apw@canonical.com>, linux-serial@vger.kernel.org,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
References: <000601ceebdc$ee148de0$ca3da9a0$%han@samsung.com>
 <20131128040750.GA29917@kroah.com>
In-reply-to: <20131128040750.GA29917@kroah.com>
Subject: Re: [PATCH 1/5] serial: 8250_pci: use DEFINE_PCI_DEVICE_TABLE macro
Date: Thu, 28 Nov 2013 14:29:17 +0900
Message-id: <006001ceebfa$c85a1020$590e3060$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7r70qA1twBffhdRoW+oAhOCVi6rAACl03w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zA921V6YFGXTNN7WYs34Nm8WHtRoW
	zYvXs1nMvv+YxeLyrjlsFmcW97I7sHnMauhl8zgx4zeLx/65a9g9vqy6xuzxeZNcAGsUl01K
	ak5mWWqRvl0CV8aKRV9ZCr5xVDxZuZq1gXEeexcjJ4eEgInE3Q/rWCFsMYkL99azdTFycQgJ
	LGOUuDD/MSNM0Yu/GxkhEosYJRbfWMcC4fwCcg48ABvFJqAm8eXLYTBbREBZYsGizywgNrPA
	CUaJ1W0iILaQQJLEto+zmUBsTgF9iQVvroDVCAv4SCzePhUsziKgKtG35CnYSbwCthJn7ryE
	sgUlfky+BzVTS2L9zuNMELa8xOY1b5m7GDmALlWXePRXF+IEI4lZnx4yQ5SISOx78Q7qmXvs
	EltOeEKsEpD4NvkQC0SrrMSmA8wQJZISB1fcYJnAKDELyeJZSBbPQrJ4FpINCxhZVjGKphYk
	FxQnpRcZ6RUn5haX5qXrJefnbmKERGzfDsabB6wPMSYDrZ/ILCWanA+M+LySeENjMyMLUxNT
	YyNzSzPShJXEeRc9TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJi8vOT+NYvj7tvKxHl6
	EladE3GVW5kds97UYP35apdNBUE3wjwrXNg2Z91carD8QXqTUeeze1zvP+0oLT+jqLO9p1xz
	xSuh9tueed0hvho/Lm5WblLya7s783tE7J02D6OEz2W9Ny5tYK5K/zdP909S2T2OXQccft9d
	q9minRZry8N2UiL4ghJLcUaioRZzUXEiALlCv4fuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jAd21V6YFGVxcZWgxZ/0aNosPazUs
	mhevZ7OYff8xi8XlXXPYLM4s7mV3YPOY1dDL5nFixm8Wj/1z17B7fFl1jdnj8ya5ANaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZKxZ9ZSn4xlHxZOVq1gbGeexdjJwc
	EgImEi/+bmSEsMUkLtxbz9bFyMUhJLCIUWLxjXUsEM4vIOfAA7AONgE1iS9fDoPZIgLKEgsW
	fWYBsZkFTjBKrG4TAbGFBJIktn2czQRicwroSyx4cwWsRljAR2Lx9qlgcRYBVYm+JU9ZQWxe
	AVuJM3deQtmCEj8m34OaqSWxfudxJghbXmLzmrfMXYwcQJeqSzz6qwtxgpHErE8PmSFKRCT2
	vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQnhGfS
	OxhXNVgcYhTgYFTi4ZXQmRYkxJpYVlyZe4hRgoNZSYRXoRgoxJuSWFmVWpQfX1Sak1p8iDEZ
	6NGJzFKiyfnAZJVXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxS
	DYyibIurLYJXbNz9+aTVmU8brHs/85/+KFT/a07Q1PYFzQJa0wy0+wytL/5/kL3t/td+zrXz
	eC7Fa385IOV6pc599/qKVbMOWi8yO9zhLNa3c+opS5akya59f6VcZkzJN7jjelj6k/7qimSJ
	L24LjrjNtBYM7sjz58i8OMFy3TR/jieRv1/uLmhUYinOSDTUYi4qTgQAIbd8D0wDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 28, 2013 1:08 PM, Greg Kroah-Hartman wrote:
> On Thu, Nov 28, 2013 at 10:55:35AM +0900, Jingoo Han wrote:
> > This macro is used to create a struct pci_device_id array.
> 
> Yeah, and it's a horrid macro that deserves to be removed, please don't
> use it in more places.
> 
> Actually, if you could just remove it, that would be best, sorry, I'm
> not going to take these patches.

(+cc Joe Perches, Andrew Morton, Andy Whitcroft)

Hi Joe Perches,

Would you fix checkpatch.pl about DEFINE_PCI_DEVICE_TABLE?
Currently, checkpatch.pl guides to use DEFINE_PCI_DEVICE_TABLE
as below.

  WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
  #331: FILE: drivers/usb/host/ehci-pci.c:331:
  +static const struct pci_device_id pci_ids [] = { {

However, Greg Kroah-Hartman mentioned that DEFINE_PCI_DEVICE_TABLE
shouldn't be used anymore.

So, would you change checkpatch.pl in order to guide to use
struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE?

For example,
  WARNING: Use struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE

Thank you.

Best regards,
Jingoo Han

