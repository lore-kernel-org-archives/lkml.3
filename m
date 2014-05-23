Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaEWRc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:32:56 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:27842 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaEWRcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:32:54 -0400
X-CheckPoint: {537F84CD-20000-2100090A-1FFFF}
Message-ID: <537F8645.6060502@tilera.com>
Date: Fri, 23 May 2014 13:32:53 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] tile: Update comments for generic idle conversion
References: <1400835265-21956-1-git-send-email-geert+renesas@glider.be> <1400835265-21956-5-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1400835265-21956-5-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/2014 4:54 AM, Geert Uytterhoeven wrote:
> As of commit 0dc8153cfebac68c9523b8852b14f10b31209f08 ("tile: Use generic
> idle loop"), this applies to arch_cpu_idle() instead of cpu_idle().
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> ---
>   arch/tile/include/asm/thread_info.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Thanks!  Taken into the linux-tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

