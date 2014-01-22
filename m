Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaAVUBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:01:18 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:53647 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752358AbaAVUBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:01:17 -0500
Date: Wed, 22 Jan 2014 21:01:13 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org, arnd@arndb.de,
        linux@roeck-us.net
Subject: Re: [PATCH] watchdog: mach-moxart: add restart handler
Message-ID: <20140122200113.GA7490@spo001.leaseweb.com>
References: <1387379883-16525-1-git-send-email-jonas.jensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387379883-16525-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonas,

> mach-moxart lacks a separate register for reset; as a workaround,
> add a function that can be hooked to arm_pm_restart.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Added to linux-watchdog-next.

> ---
> 
> Notes:
>     During review of this driver, the restart handler for moxart was
>     removed, and moved to platform code under arch/arm/mach-moxart/.
>     
>     Since then, new considerations arrived,
>     see replies from Arnd and Guenter:
>     
>     "[PATCH v4 1/2] ARM: mach-moxart: add MOXA ART SoC platform files"
>     http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/219175.html
>     
>     I can move this to a new power/restart driver, but first, I want to
>     hear what Wim or others think.
>     
>     Until there is a better solution, my motivation is that this uses
>     the watchdog. The way I see it, the problem is that there is no
>     separate register for reset, this was always a workaround for that.
>     
>     Applies to next-20131218

Will review this again after the merge window is over.

Kind regards,
Wim.

