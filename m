Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaH2U2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:28:54 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:52658 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaH2U2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:28:53 -0400
X-CheckPoint: {5400E285-A-2100090A-C0000000}
Message-ID: <5400E284.3020304@tilera.com>
Date: Fri, 29 Aug 2014 16:28:52 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tile: Remove tile-specific _sinitdata and _einitdata
References: <1409343516-5132-1-git-send-email-geert@linux-m68k.org> <1409343516-5132-4-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1409343516-5132-4-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/2014 4:18 PM, Geert Uytterhoeven wrote:
> Use standard __init_begin and __init_end instead.
>
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>
> Acked-by: Chris Metcalf<cmetcalf@tilera.com>
> ---
>   arch/tile/include/asm/sections.h |  3 ---
>   arch/tile/kernel/vmlinux.lds.S   |  2 --
>   arch/tile/mm/init.c              | 10 +++++-----
>   3 files changed, 5 insertions(+), 10 deletions(-)

This is still in the tile tree; I missed the merge window for 3.17
since I was lazing around on the beach, but I'll push it to Linus
for 3.18.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

