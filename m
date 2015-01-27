Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbbA0CmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 21:42:10 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59102 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbA0CmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 21:42:06 -0500
Date: Mon, 26 Jan 2015 18:42:06 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup/soc for 3.20 #3 (bis)
Message-ID: <20150127024206.GC22154@quad.lixom.net>
References: <20150123230609.GV20896@quad.lixom.net>
 <1422277230-25211-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422277230-25211-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 02:00:30PM +0100, Nicolas Ferre wrote:
> 
> Arnd, Olof, Kevin,
> 
> This is the rework of my previous pull-request with modifications advised by
> Olof.
> This is a batch of cleanup/soc modifications that you may also stack on top of
> your "soc" branch as the previous one. It stabilizes a little bit our cleanup
> action before going further.
> Another one may be proposed before the merge-window opens.
> 
> Thanks, best regards,
> 
> The following changes since commit 29ee506d0d56f6d39cc237de2512f9cb5629cbf7:
> 
>   ARM: at91: move at91rm9200_idle() to clk/at91/pmc.c (2015-01-16 18:08:42 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-cleanup3
> 
> for you to fetch changes up to 9726b6892beeaa736610370429a23a481d1b133e:
> 
>   ARM: at91: pm: remove warning to remove SOC_AT91SAM9263 usage (2015-01-26 13:44:19 +0100)

Merged, thanks.


-Olof
