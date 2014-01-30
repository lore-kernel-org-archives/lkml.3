Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaA3Eqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 23:46:39 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:51635 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaA3Eqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 23:46:37 -0500
MIME-Version: 1.0
In-Reply-To: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
Date: Thu, 30 Jan 2014 10:16:37 +0530
Message-ID: <CAK9yfHzBfGQgCwhZ1M5MLw9KWrtTaHf+nvY9r6JV01rq4JE15g@mail.gmail.com>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 January 2014 03:34, Yinghai Lu <yinghai@kernel.org> wrote:
> In original bootmem wrapper for memblock, we have limit checking.
>
> Add it to memblock_virt_alloc, to address arm and x86 booting crash.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---

Confirmed that this patch fixes the boot crash issue on Exynos (ARM
based) boards.

Tested-by: Sachin Kamat <sachin.kamat@linaro.org>

-- 
With warm regards,
Sachin
