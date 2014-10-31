Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbaJaNxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:53:54 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:43771 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317AbaJaNxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:53:53 -0400
X-CheckPoint: {54539470-3-2100090A-C0000000}
Message-ID: <5453946F.3030803@tilera.com>
Date: Fri, 31 Oct 2014 09:53:51 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Remove use of early_vprintk, tile neatening
References: <cover.1414691783.git.joe@perches.com>
In-Reply-To: <cover.1414691783.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [108.49.132.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 2:11 PM, Joe Perches wrote:
> Joe Perches (3):
>    printk: Remove used-once early_vprintk
>    tile: Neaten early_printk uses
>    tile: Use pr_warn instead of pr_warning
>
>   arch/tile/kernel/early_printk.c | 19 +++++++++++------
>   arch/tile/kernel/setup.c        | 45 ++++++++++++++++++-----------------------
>   include/linux/printk.h          |  1 -
>   kernel/printk/printk.c          | 19 ++++++++---------
>   4 files changed, 41 insertions(+), 43 deletions(-)
>

You can put my

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

on this series.  Looks like akpm is taking it into -mm so I won't bother to take it into the tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

