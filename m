Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbaD3Ilr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:41:47 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:61802 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163AbaD3Ilo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:41:44 -0400
MIME-Version: 1.0
In-Reply-To: <1398835057-3860-6-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
	<1398835057-3860-6-git-send-email-pankaj.dubey@samsung.com>
Date: Wed, 30 Apr 2014 14:11:43 +0530
Message-ID: <CAK9yfHy8kbNk6mVZy_ARiWZ8kLbn7r7R8vj+3ETCcGsASQZsCw@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] ARM: EXYNOS: Remove file path from comment section
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>,
        VIKAS SAJJANC <vikas.sajjan@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 30 April 2014 10:47, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> Many files under "arm/mach-exynos" are having file path in file
> comment section which is invalid now.
> So for better code maintainability let's remove them.
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---

The change is sensible. However Kukjin had refused to accept such patches
when I had submitted patches doing such cleanup for all Samsung platform files.

Anyway, FWIW
Reviewed-by: Sachin Kamat <sachin.kamat@linaro.org>

-- 
With warm regards,
Sachin
