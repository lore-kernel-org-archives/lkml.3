Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbbAWXGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:06:11 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50035 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbbAWXGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:06:09 -0500
Date: Fri, 23 Jan 2015 15:06:09 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup/soc for 3.20 #3
Message-ID: <20150123230609.GV20896@quad.lixom.net>
References: <1422033307-9702-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422033307-9702-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 06:15:07PM +0100, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This is a batch of cleanup/soc modifications that you may also stack on top of
> your "soc" branch as the previous one. It stabilizes a little bit our cleanup
> action before going further.
> I also have the feeling that multi-platform would be hard to reach for 3.20...
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
> for you to fetch changes up to d7b943cd96a1196a7e4f8ae48fc16a086ccc9a6a:
> 
>   ARM: at91: pm: remove warning to remove SOC_AT91SAM9263 usage (2015-01-23 12:35:50 +0100)
> 

Hi,

I had a comment on the very first patch in this branch, so please address that
and send a fresh pull request.


Thanks,

-Olof
