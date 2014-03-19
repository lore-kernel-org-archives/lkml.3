Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbaCSJ01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:26:27 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63592 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061AbaCSJ0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:26:25 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-05-532962be0f94
Message-id: <1395221180.14558.4.camel@AMDC1943>
Subject: Re: [PATCH 0/5] rtc: s5m: Add support for S2MPS14
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>
Date: Wed, 19 Mar 2014 10:26:20 +0100
In-reply-to: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
References: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xK7r7kjSDDWaf4bNYcvEqu8XGGetZ
	Lc42vWG3uP/1KKPF5V1z2CzWHrnLbrG/s4PR4nQ3q8XFFV+YLNbPeM3iwOWxZ+JJNo871/aw
	ecw7GejRt2UVo8f0eT+ZPD5vkgtgi+KySUnNySxLLdK3S+DKOHRxBkvBeZ6K1tNJDYyvOLsY
	OTkkBEwkTjy9wQphi0lcuLeerYuRi0NIYCmjxIfL19hBEkICnxklXi63B7F5BfQlWk9+YQSx
	hQWsJDbdPcAMYrMJGEtsXr4EqJmDQ0RAW6J3UhpImFngEZPEhIVqIDaLgKpE+6r7YCM5BTwk
	Tj6fwgox3l3i3uqtzBD16hKT5i1ihrhHSWJ3eyc7RFxeYvOat8wQJwhK/Jh8j2UCo8AsJC2z
	kJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIFHzZwbj4mNUhRgEORiUeXslY
	jWAh1sSy4srcQ4wSHMxKIrwfEzSDhXhTEiurUovy44tKc1KLDzEycXBKNTBWJylVzDYpOb12
	yROnb4dtV3KZlWyY9W7j6hubj007/XXTcrcYwfbQSzz3OKMvXj37M/FHCp9hvP9xudei77c0
	Gd1nOZqY8HK5Xe+2fo0W2f+L1u6NesPfo3JJUkXB2fVefXhJnI97hpeAmpDCtIv6rLHbP+a2
	R5jcXr/Z6thTlreqwawv2tyUWIozEg21mIuKEwEEP8nXYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alessandro Zummo,

I'm humbly reminding myself :). If these patches are OK can I have an
Ack from you so Lee Jones could apply them to MFD tree?

Best regards,
Krzysztof Kozlowski



On Fri, 2014-02-28 at 14:00 +0100, Krzysztof Kozlowski wrote:
> Hi,
> 
> 
> Few days ago I sent patches adding support for S2MPS14 device to the
> sec-core/s2mps11 drivers. These patches were rather large as they covered
> multiple subsystems so I decided to split everything into smaller, separate
> patches.
> 
> The original patchset (version 3) can be found here:
> http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27194/focus=1649217
> 
> This patchset is a small subset of above related to the S5M RTC driver.
> It adds support for the S2MPS14 device.
> 
> These patches are rebased against Lee's "for-mfd-next" tree because they require
> changes in main MFD sec-core driver ("Add support for S2MPS14 for-mfd-next",
> which is already in Lee's "for-mfd-next" tree).
> 
> 
> Best regards,
> Krzysztof
> 
> Krzysztof Kozlowski (5):
>   mfd/rtc: sec/s5m: Rename SEC* symbols to S5M
>   rtc: s5m: Remove undocumented time init on first boot
>   rtc: s5m: Use shorter time of register update
>   rtc: s5m: Support different register layout
>   rtc: s5m: Add support for S2MPS14 RTC
> 
>  drivers/mfd/sec-core.c          |    2 +-
>  drivers/rtc/Kconfig             |    4 +-
>  drivers/rtc/rtc-s5m.c           |  291 ++++++++++++++++++++++++++-------------
>  include/linux/mfd/samsung/rtc.h |   86 +++++++-----
>  4 files changed, 249 insertions(+), 134 deletions(-)
> 

