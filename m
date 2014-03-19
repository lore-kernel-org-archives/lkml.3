Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965331AbaCSOWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:22:46 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:42865 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965253AbaCSOWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:22:44 -0400
Date: Wed, 19 Mar 2014 15:22:32 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-leds@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 14/16] backlight: atmel-pwm-bl: remove obsolete driver
Message-ID: <20140319142231.GF20872@samfundet.no>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395234209-15546-15-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395234209-15546-15-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 19 Mar 2014 14:03:27 +0100 or thereabout, Alexandre Belloni wrote:
> The atmel-pwm-bl driver is now obsolete. It is not used by any mainlined boards
> and is replaced by the generic pwm_bl with the pawm-atmel driver using the
> generic PWM framework.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  drivers/video/backlight/Kconfig        |  11 --
>  drivers/video/backlight/Makefile       |   1 -
>  drivers/video/backlight/atmel-pwm-bl.c | 223 ---------------------------------
>  include/linux/atmel-pwm-bl.h           |  43 -------
>  4 files changed, 278 deletions(-)
>  delete mode 100644 drivers/video/backlight/atmel-pwm-bl.c
>  delete mode 100644 include/linux/atmel-pwm-bl.h

<snipp diff>

> -MODULE_AUTHOR("Hans-Christian egtvedt <hans-christian.egtvedt@atmel.com>");
>

sob )':

Great cleanup though.

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
