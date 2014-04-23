Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaDWJTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:19:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62064 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaDWJTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:19:33 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-a9-535785a2c470
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Jingoo Han'" <jg1.han@samsung.com>
Cc: "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, "'Liviu Dudau'" <Liviu.Dudau@arm.com>,
        "'Byungho An'" <bh74.an@samsung.com>, ilho215.lee@samsung.com
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
 <000a01cf592e$67e592e0$37b0b8a0$%han@samsung.com>
 <201404221611.40087.arnd@arndb.de>
In-reply-to: <201404221611.40087.arnd@arndb.de>
Subject: RE: [RFC PATCH 2/2] PCI: exynos: Add PCIe support for Samsung GH7 SoC
Date: Wed, 23 Apr 2014 18:19:30 +0900
Message-id: <031b01cf5ed5$21d536a0$657fa3e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQE7j5vEO2bPBvFlE8X5JkO9YLQfLwI5mSp5AVCKzFycKjZeUA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zQ91FreHBBhtOm1n8nXSM3eLquWOM
	FkuaMiyO/lvIaHF54SVWi/eHnjFbbHp8jdXi8q45bBZn5x1nsziwtJ3Fgctjzbw1jB6/f01i
	9FiwqdRj85J6j9v/HjN79G1ZxejxeZNcAHsUl01Kak5mWWqRvl0CV8aZDTfZC7q4K1reP2Bs
	YLzD0cXIySEhYCLRO+UMG4QtJnHh3nogm4tDSGAZo8TUXW+YYYp+L7/GCpGYziixpn8vC4Tz
	l1Gi7+51sCo2AQ2Jw++fsXcxcnCICLhLNJ4oA6lhFljAJPF373uwGiGBaYwSs28Jg9icAvoS
	a1ZPAFstLOAnsWTBSTCbRUBVouniWSYQm1fAUuJ310RWCFtQ4sfkeywgNrOAlsT6nceZIGx5
	ic1r3kJdqiCx4+xrRhBbRMBJ4t3fN+wQNSIS+168YwQ5SEJgKofEuv0boJYJSHybfIgF5GgJ
	AVmJTQeg5khKHFxxg2UCo8QsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5kqlecmFtcmpeu
	l5yfu4kREu0TdzDeP2B9iDEZaP1EZinR5HxgssgriTc0NjOyMDUxNTYytzQjTVhJnDf9UVKQ
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbzqxVKbaxEdIq/xF+0sUy7Zb/p7T6LaO2ND7+X
	8d1Qd4r5fnDVt0y/i0KFHNcm7b4+PWGzF2vT7eUPtd51/s6dsOeRpuLz0hl6NrtsLrCUHlM6
	/jTf+kyNzrRlrTOYIxbdfJISzFS5ec7DL9p8FSuvMZadyWW8vSjo1h6NWbP3ebWmb173VMpa
	iaU4I9FQi7moOBEAbbcpfAwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQd1FreHBBi23DC3+TjrGbnH13DFG
	iyVNGRZH/y1ktLi88BKrxftDz5gtNj2+xmpxedccNouz846zWRxY2s7iwOWxZt4aRo/fvyYx
	eizYVOqxeUm9x+1/j5k9+rasYvT4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhHWPGmQ032Qu6uCta3j9gbGC8w9HFyMkhIWAi8Xv5NVYIW0ziwr31bF2MXBxCAtMZ
	Jdb072WBcP4ySvTdvc4MUsUmoCFx+P0z9i5GDg4RAXeJxhNlIDXMAguYJP7ufQ9WIyQwjVFi
	9i1hEJtTQF9izeoJbCC2sICfxJIFJ8FsFgFViaaLZ5lAbF4BS4nfXRNZIWxBiR+T77GA2MwC
	WhLrdx5ngrDlJTavecsMcamCxI6zrxlBbBEBJ4l3f9+wQ9SISOx78Y5xAqPQLCSjZiEZNQvJ
	qFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4lz6R2MK5ssDjEKMDBqMTDW7Ay
	LFiINbGsuDL3EKMEB7OSCO+xuvBgId6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4Hprm8knhD
	YxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamCs+Jxx7uYHn8cp726e
	k7oculmxZO8HvVgBiRaOUws+OCx1Y3iq8qb35pHvgRF9zBHPihjE7G7t/T/Bcr7DPYmtUzZW
	/bcSZdCJVTwo/2tZ4/9d5UnX37ZYtiiJeT4Szu5bt+BFxgTJr4WOJ0S2Ob/ZVO/k1Lnxltrs
	xX/XdxcucVQr32nyUPG9EktxRqKhFnNRcSIA3UMSyGkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> On Wednesday 16 April 2014, Jingoo Han wrote:
> > Samsung GH7 has four PCIe controllers which can be used as root
> > complex for PCIe interface.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/pci/host/Kconfig      |    2 +-
> >  drivers/pci/host/pci-exynos.c |  135
> ++++++++++++++++++++++++++++++++++++++---
> >  2 files changed, 126 insertions(+), 11 deletions(-)
> 
+ Byungho An, Ilho Lee

Hi Arnd,

> Can you explain how much the GH7 and Exynos front-ends actually have in
> common? Would it make sense to have a separate driver for gh7?
> 
Basically, ARMv8 based GH7 has same PCIe hardware IP with previous ARMv7
based exynos5440, several features in PCIe are different though. In other
words, basic functionalities for PCIe are same. So I think, would be nice if
we could use one PCIe device driver for both SoCs.

However, if we need to support the PCIe with each own device driver because
of difference of 32bit and 64bit, please kindly let us know. Honestly, I'm
not sure about that right now.

> Also, if gh7 is expected to run a full firmware, I think you should
> do all the setup in the firmware before booting Linux, and just
> do the required run-time operations in the driver itself.
> 
Well, we're expecting that all the setup should be done by the device driver
in kernel not firmware.

Thanks,
Kukjin

