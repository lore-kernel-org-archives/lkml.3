Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3KUNHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:07:11 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:62267 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3KUNHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:07:08 -0500
Message-ID: <528E059C.9050408@gmail.com>
Date: Thu, 21 Nov 2013 14:07:40 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>, "'Borislav Petkov'" <bp@alien8.de>,
        "'Wei WANG'" <wei_wang@realsil.com.cn>
CC: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Chris Ball'" <cjb@laptop.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <20131117195358.GO27323@pd.tnic> <CAC9WiBggfssh+31_MqVCT-hDf2E8zTuc81q-DhLYQuVF053mEA@mail.gmail.com> <20131117220611.GQ27323@pd.tnic> <528A05D0.30907@gmail.com> <20131118133210.GG24851@pd.tnic> <528B36EA.20301@gmail.com> <20131119101521.GA3515@pd.tnic> <528C84A1.5030707@gmail.com> <20131120111541.GA30147@pd.tnic> <528DC2AA.4070202@gmail.com> <20131121101234.GB25459@pd.tnic> <000801cee6ab$4e9f9380$ebdeba80$%han@samsung.com>
In-Reply-To: <000801cee6ab$4e9f9380$ebdeba80$%han@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/21/2013 12:17 PM, Jingoo Han wrote:
[...]
> 
> In my opinion, rtsx_pci_resume()/rtsx_pci_suspend() in realtek PCIe card
> reader driver may make the kernel panic.
> 
> I think that the commit "mfd: rtsx: Configure to enter a deeper
> power-saving mode in S3" may be the culprit.

I'll do the check tonight.

> 
> Francis Moreau,
> Let us know the exact model name of rts52xx PCIe card reader
> in your laptop? According to the commit, Wei WANG added S3 mode
> to rts5227 driver ,and rts5249 driver.

03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. Device
[10ec:5289] (rev 01)
	Subsystem: CLEVO/KAPOK Computer Device [1558:0540]
	Flags: bus master, fast devsel, latency 0, IRQ 40
	Memory at f7200000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Endpoint, MSI 00
	Capabilities: [b0] MSI-X: Enable- Count=1 Masked-
	Capabilities: [d0] Vital Product Data
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: rtsx_pci
	Kernel modules: rtsx_pci

Thanks,

