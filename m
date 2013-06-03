Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3FCKEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:04:01 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43501 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab3FCKD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:03:59 -0400
Date: Mon, 3 Jun 2013 11:03:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Srinidhi Kasagar'" <srinidhi.kasagar@stericsson.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: Re: [PATCH V2] mfd: replace strict_strtoul() with kstrtoul()
Message-ID: <20130603100354.GE3370@gmail.com>
References: <000801ce6039$526d9a00$f748ce00$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000801ce6039$526d9a00$f748ce00$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.

Andy,

Would you mind re-reviewing and providing the appropriate *-by please?

If you're happy I'll take the patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
