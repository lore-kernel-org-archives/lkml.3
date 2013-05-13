Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3EMKoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:44:55 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:54555 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3EMKoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:44:54 -0400
Date: Mon, 13 May 2013 11:44:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] mfd: ab8500-sysctrl: Always enable pm_power_off handler
Message-ID: <20130513104448.GB3297@gmail.com>
References: <1368097688-17858-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1368097688-17858-1-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 May 2013, Fabio Baltieri wrote:

> AB8500 sysctrl driver implements a pm_power_off handler, but that is
> currently not registered until a specific platform data field is
> enabled.
> 
> This patch drops the platform data field and always registers
> ab8500_power_off if no other pm_power_off handler was defined before,
> and also introduces the necessary cleanup code in the driver's remove
> function.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  drivers/mfd/ab8500-sysctrl.c      | 6 +++++-
>  include/linux/mfd/abx500/ab8500.h | 2 --
>  2 files changed, 5 insertions(+), 3 deletions(-)

The code looks good to me, but I'd like Linus' or Mattias' Ack before
I apply it.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
