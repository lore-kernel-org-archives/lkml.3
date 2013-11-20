Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3KTXsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:48:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43891 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab3KTXsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:48:02 -0500
Message-ID: <528D4A1A.2050100@zytor.com>
Date: Wed, 20 Nov 2013 15:47:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: enable DMA CMA with swiotlb
References: <1384903939-3371-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1384903939-3371-1-git-send-email-akinobu.mita@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 03:32 PM, Akinobu Mita wrote:
> The DMA Contiguous Memory Allocator support on x86 is disabled when
> swiotlb config option is enabled.  So DMA CMA is always disabled on
> x86_64 because swiotlb is always enabled.  This attempts to support
> for DMA CMA with enabling swiotlb config option.

What is the use case?

	-hpa


