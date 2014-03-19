Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300AbaCSOVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:21:22 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:34249 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054AbaCSOVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:21:19 -0400
Date: Wed, 19 Mar 2014 15:21:07 +0100
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
Subject: Re: [PATCH 13/16] avr32: update defconfig to use the generic PWM
 framework
Message-ID: <20140319142107.GE20872@samfundet.no>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395234209-15546-14-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395234209-15546-14-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 19 Mar 2014 14:03:26 +0100 or thereabout, Alexandre Belloni wrote:
> Now that all boards have switch to the generic PWM framework, update the
> defconfigs to use it.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/configs/atngw100_mrmt_defconfig | 5 +++--
>  arch/avr32/configs/atstk1002_defconfig     | 5 +++--
>  arch/avr32/configs/atstk1003_defconfig     | 5 +++--
>  arch/avr32/configs/atstk1004_defconfig     | 5 +++--
>  arch/avr32/configs/atstk1006_defconfig     | 5 +++--
>  arch/avr32/configs/merisc_defconfig        | 5 +++--
>  6 files changed, 18 insertions(+), 12 deletions(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
