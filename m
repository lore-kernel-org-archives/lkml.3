Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaKIAyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 19:54:23 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63675 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbaKIAyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 19:54:22 -0500
Date: Sat, 8 Nov 2014 16:54:20 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: dt for 3.19 #1
Message-ID: <20141109005420.GB13855@quad.lixom.net>
References: <1415036597-3501-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415036597-3501-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 06:43:17PM +0100, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> Very little DT update for AT91. More will come but I want to send this first
> batch soon so it doesn't get in the way of larger modifications.
> 
> Thanks, best regards,
> 
> The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:
> 
>   Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-dt
> 
> for you to fetch changes up to 2667c6adfcf686e8c5a5b56e8c7c65af001df2cb:
> 
>   ARM: at91/dt: at91sam9263: Add CAN device nodes (2014-11-03 11:34:33 +0100)
> 
> ----------------------------------------------------------------
> First DT batch for 3.19:
> - CAN device nodes for at91sam9263 and at91sam9x5
> - at91sam9x5 DMA definitions for usart

Merged, thanks.


-Olof
