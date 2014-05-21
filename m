Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaEUPYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:24:22 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54420 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaEUPYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:24:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        andriy.shevchenko@intel.com
Subject: Re: [PATCH v8 0/2] Add support for the Allwinner A31 DMA Controller
Date: Wed, 21 May 2014 17:23:41 +0200
Message-ID: <4828893.NoTbcUXQEt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400685357-508-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1400685357-508-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:c4Pw/QjBmcMrQ2X/dJ6Jdvm1G45WUSFFpO6h6pPiYB2
 zmyFwovu0ajhAxbN0/sShkctZBfLVFuiMguqvWFFYmqCy5XIws
 9xOVGKkns1+3CU7+f5o3ECaUyTPCa4DuasYWpTPCsvbAdB2ryG
 8dbwMow/gEiUSVnyuEyr9o6rHeQIpSFDj7tEF7fbZk+3uSsmgr
 FVnJL0Yb4LDREGJinrtPWV23T5h8Vfh5tnXkZJ7hhk1iymRyZr
 1FPf9d4KSI9TIm3vGHLDddoNES8Svf5qp+GgY2+ffVMZ+g9wxG
 lfGlgNIUud01jOVOBQtc44i0OmLhh5aYYk4/pRDfaF4y5IoVg2
 dw+iypP12oLYKEnkWiRM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 17:15:54 Maxime Ripard wrote:
> Changes from v7:
>   - select DMA_OF, since we're only relying on DT
> 

I missed the discussion about this issue, but it seems wrong to me.
DMA_OF is currently enabled if we have both DMAENGINE and OF turned on.

If OF is disabled but DMA_OF gets selected by DMA_SUN6I, what happens?

	Arnd
