Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833Ab3FDHXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:23:24 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:63801 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3FDHXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:23:20 -0400
Date: Tue, 4 Jun 2013 08:23:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Srinidhi Kasagar'" <srinidhi.kasagar@stericsson.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: Re: [PATCH V3] mfd: replace strict_strtoul() with kstrtoul()
Message-ID: <20130604072314.GJ3370@gmail.com>
References: <001101ce60d9$a39936a0$eacba3e0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <001101ce60d9$a39936a0$eacba3e0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Jun 2013, Jingoo Han wrote:

> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> Changes since v1:
> - Removed redundant variables 'u8 reg'.
> - Changed the type of 'user_value' from 'unsigned long' to 'u8'.
> - Replaced kstrtoul() with kstrtou8() to handle u8 variable.
> - Added Andy Shevchenko's Reviewed-by.
> 
> Changes since v1:
> - Used return code from kstrtoul().
> - Changed the type of 'user_reg' from 'unsigned long' to 'u8'.
> - Replaced kstrtoul() with kstrtou8() to handle u8 variable.
> 
>  drivers/mfd/aat2870-core.c   |    5 +++--
>  drivers/mfd/ab3100-core.c    |   28 ++++++++++------------------
>  drivers/mfd/ab8500-debugfs.c |    2 +-
>  3 files changed, 14 insertions(+), 21 deletions(-)

Applied.

If Andy has any further comments, I'll replace the applied version
with any v3 patch which you send.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
