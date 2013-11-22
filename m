Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab3KVPCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:02:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39870 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665Ab3KVPCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:02:45 -0500
Message-ID: <528F71F8.4070902@zytor.com>
Date: Fri, 22 Nov 2013 07:02:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: enable DMA CMA with swiotlb
References: <1384903939-3371-1-git-send-email-akinobu.mita@gmail.com>	<528D4A1A.2050100@zytor.com>	<CAC5umyh0Hfx3NgHX11eqskuifhrdYGB8L1nx1u0YUdBGchRTxw@mail.gmail.com>	<528E4CBA.8000808@zytor.com> <CAC5umygUgSjUMFECDXAjmSPzpfUZ6=jRhZWhd5hTT2-eO6Oh6Q@mail.gmail.com>
In-Reply-To: <CAC5umygUgSjUMFECDXAjmSPzpfUZ6=jRhZWhd5hTT2-eO6Oh6Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 04:27 AM, Akinobu Mita wrote:
> 
> I'm currently working for integrating DMA CMA with intel-iommu which
> I can test.  Regardless of which dma ops is actually used, I would
> like to allocate large contiguous memory with dma_alloc_coherent()
> and tell the base address to the device.
> 
> We can use mem= or crashkernel= to reserve host memory, but it is
> complicated and unables to work with real IOMMU.
> 

If you have a real iotlb, why would you need contiguous memory?

	-hpa

