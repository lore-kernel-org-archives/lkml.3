Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3H1X7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 19:59:36 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60037 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3H1X7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 19:59:34 -0400
Date: Wed, 28 Aug 2013 16:58:55 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Bo Shen <voice.shen@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: soc update for 3.12 #1
Message-ID: <20130828235855.GM8607@quad.lixom.net>
References: <1377532543-349-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377532543-349-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 05:55:43PM +0200, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> Here is AT91 SoC updates for 3.12 kernel. It is the first pull-request for
> this topic and it is based on 3.11-rc5 like your next/soc branch.
> 
> Thanks, best regards,
> 
> The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:
> 
>   Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-soc
> 
> for you to fetch changes up to 99eb3b40ec42e7fce1fc58429bf9b26c17973c12:
> 
>   ARM: at91: at91_dt_defconfig: enable rm9200 support (2013-08-26 09:58:29 +0200)
> 
> ----------------------------------------------------------------
> AT91 SoC update for 3.12 take 1
> - enable kernel uncompress information output for
>   SoC where it was missing: at91sam9n12 and sama5d3
> - addition of at91rm9200 to the generic at91_dt_defconfig
> 
> ----------------------------------------------------------------
> Jean-Christophe PLAGNIOL-VILLARD (1):
>       ARM: at91: at91_dt_defconfig: enable rm9200 support
> 
> voice (4):
>       ARM: at91: sama5d3: add definition for usart base address
>       ARM: at91: include sama5d3.h into hardware.h
>       ARM: at91: sama5: enable kernel uncompress info output
>       ARM: at91: sam9n12: enable kernel uncompress info output

That doesn't look right. Author should probably be "Bo Shen
<voice.shen@atmel.com>" instead. Can you fixup and respin, please?


-Olof
