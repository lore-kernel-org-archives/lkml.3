Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab3ARPHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:07:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49684 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3ARPHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:07:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 73/76] ARC: [Review] Multi-platform image #6: cpu-to-dma-addr optional
Date: Fri, 18 Jan 2013 15:07:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358512827-7694-1-git-send-email-vgupta@synopsys.com> <1358512827-7694-2-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358512827-7694-2-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181507.33094.arnd@arndb.de>
X-Provags-ID: V02:K0:ivWgk0sHO7VV5xu1eJqHbq3f+ejbq1vHeLvd2t5X91T
 rHuXFGjgmLZLgpwb5y0RZVtgKA1lfDpFZK4vovjmXoncnKLkRH
 nVmI0PEo2pwE08f3SUCNIk2Lz4DUVhgWUZpdp04Fzr6u7YnrNe
 861tiI/i4wGhyun0dpxV98jxG0PoYamHLmY/Ngf3XZwBZRkxXO
 /ewY2aTB6KuetFC0YOOPAw6PI0aglYni4p/sxtnwLcxbHXhaY2
 7rD0E5J0OUJC3ksWA5Am02CV/B0LtsSmayfjP/JIZWF/btmQGA
 Nh0gtjv1LNeTz2uKF34G/EUGDQk7aGlxTn2ZzFSQDCde2VHS/J
 Adgr+mCxiqos1eHbh/lc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> All the current platforms can work with 0x8000_0000 based dma_addr_t
> since the Bus Bridges typically ignore the top bit (the only excpetion
> was Angel4 PCI-AHM bridge which we no longer care for).
> That way we don't need plat-specific cpu-addr to bus-addr conversion.
> 
> Hooks still provided - just in case a platform has an obscure device
> which say needs 0 based bus address.
> 
> That way <asm/dma_mapping.h> no longer needs to unconditinally include
> <plat/dma_addr.h>
> 
> Also verfied that on Angel4 board, other peripherals (IDE-disk / EMAC)
> work fine with 0x8000_0000 based dma addresses.
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
