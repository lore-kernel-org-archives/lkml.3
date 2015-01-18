Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbbARS3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 13:29:14 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62290 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbARS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 13:29:03 -0500
Message-ID: <54BBFB6A.5060104@linaro.org>
Date: Sun, 18 Jan 2015 19:28:58 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Robert Jarzmik <robert.jarzmik@free.fr>, Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] pxa_timer: fix session missmatch warning
References: <1421286860-23296-1-git-send-email-dbaryshkov@gmail.com>
In-Reply-To: <1421286860-23296-1-git-send-email-dbaryshkov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 02:54 AM, Dmitry Eremin-Solenikov wrote:
> Fix the following warning:
>
> WARNING: drivers/clocksource/built-in.o(.text.unlikely+0x70): Section mismatch in reference from the function pxa_timer_common_init() to the function .init.text:clocksource_mmio_init()
> The function pxa_timer_common_init() references
> the function __init clocksource_mmio_init().
> This is often because pxa_timer_common_init lacks a __init
> annotation or the annotation of clocksource_mmio_init is wrong.
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com

Applied to my tree.

Thanks !

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

