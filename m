Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3FMGFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 02:05:07 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45795 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3FMGFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 02:05:05 -0400
Message-ID: <51B9610A.20202@linaro.org>
Date: Thu, 13 Jun 2013 11:34:58 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com
CC: arnd@arndb.de, olof@lixom.net, patches@linaro.org,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH v2 3/3] ARM: s5p64x0: Use common uncompress.h part for
 plat-samsung
References: <1370319552-17694-1-git-send-email-tushar.behera@linaro.org> <1370319552-17694-4-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1370319552-17694-4-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 09:49 AM, Tushar Behera wrote:
> From: Tomasz Figa <tomasz.figa@gmail.com>
> 
> Since uart_base can be set dynamically in arch_detect_cpu(), there is no
> need to have a copy of all code locally, just to override UART base
> address.
> 
> This patch removes any duplicate code in uncompress.h variant of s5p64x0
> and implements proper arch_detect_cpu() function to initialize UART with
> SoC-specific parameters.
> 
> While at it, replace hard-coded register address with macro.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
> (This patch replaces the original patch in this patchset as it was an
> earlier-posted near-identical patch.)
> 
> Changes for v2:
> * Remove the declaration of uart_base (taken care in plat/uncompress.h)
> 

Kukjin,

Would you please queue this up for 3.11?

Thanks.

-- 
Tushar Behera
