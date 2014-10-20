Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaJTTF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:05:29 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:52007 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaJTTFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:05:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-mm-sig@lists.linaro.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Josh Cartwright <joshc@codeaurora.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [Linaro-mm-sig] [PATCH v4] drivers: of: add return value to of_reserved_mem_device_init
Date: Mon, 20 Oct 2014 21:04:40 +0200
Message-ID: <3202272.i0Lr6KJ3g8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413370902-28187-1-git-send-email-m.szyprowski@samsung.com>
References: <13963062.ORRNOhrvYD@wuerfel> <1413370902-28187-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OZrSE89NRW2B2UWqCjLl27PFWchz0TcNYhLh/u3JBjT
 wpR3xMd1fiWrEagPcueEXudfUV2j9DQWZ8IoZhIFn0lApoZnW8
 VVljpUhy6chLDdriZ7iUTjBT+yX8EL3suHO8H7tWinupkbcnp3
 30xiIMjPNUVz50GO3grXI6NnnkKxUTUcX5JDAeDFE6Mew2S7QU
 oaw8ABeIuBe5/tDSkNdK2R4AqyJiPy5SiPyg1lT9lleSmlRin6
 2ugRbsxRmNxMvYgnm0tLKgFp6TCFks9OHIAMwVXf1Lk2aevVS8
 7J9WhpXcRP92ZRRMFmYQvnkal94chy5XlnvjaRW61sg1U9PesL
 PV31VojpHPJlNy0R1T7c=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 October 2014 13:01:42 Marek Szyprowski wrote:
> Driver calling of_reserved_mem_device_init() might be interested if the
> initialization has been successful or not, so add support for returning
> error code.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
> This patch fixes build warining caused by commit
> 7bfa5ab6fa1b18f53fb94f922e107e6fbdc5e485 ("drivers: dma-coherent: add
> initialization from device tree"), which has been merged without this
> change and without fixing function return value.
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

It also makes sense to encode the information you have below the ---
line as

Fixes: 7bfa5ab6fa1b1 ("drivers: dma-coherent: add initialization from device tree")
