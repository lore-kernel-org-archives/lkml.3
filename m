Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaBKSuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:50:19 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:51258 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaBKSuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:50:17 -0500
Date: Tue, 11 Feb 2014 10:50:13 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] mtd: Remove unnecessary OOM messages
Message-ID: <20140211185013.GH18440@ld-irv-0074>
References: <000201cf2301$b168d250$143a76f0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000201cf2301$b168d250$143a76f0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 03:07:19PM +0900, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message. For example,
> k.alloc and v.alloc failures use dump_stack().
> 
> Jingoo Han (8):
>       mtd: devices: elm: Remove unnecessary OOM messages
>       mtd: spear_smi: Remove unnecessary OOM messages
>       mtd: pmc551: Remove unnecessary OOM messages
>       mtd: plat-ram: Remove unnecessary OOM messages
>       mtd: lpddr: Remove unnecessary OOM messages
>       mtd: onenand: Remove unnecessary OOM messages
>       mtd: cfi: Remove unnecessary OOM messages
>       mtd: gen_probe: Remove unnecessary OOM messages

Pushed all 8 to l2-mtd.git. Thanks.

Have you ever considered using a tool like coccinelle to do this sort of
work? You send so many of these boilerplate patch series, I would think
it would help everyone to just get them out of the way with scripted
assistance. And you could then more easily catch new introductions if
they slip through the review process.

Brian
