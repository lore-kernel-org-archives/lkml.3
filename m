Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941Ab3IFJhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 05:37:25 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:60537 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3IFJhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 05:37:24 -0400
Date: Fri, 6 Sep 2013 10:37:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, anton@enomsg.org, dwmw2@infradead.org
Subject: Re: [PATCH v3 3/4] pm2301-charger: Check return value of
 regulator_enable
Message-ID: <20130906093719.GE32654@lee--X1>
References: <1378454473-24508-1-git-send-email-sachin.kamat@linaro.org>
 <1378454473-24508-3-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378454473-24508-3-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Sep 2013, Sachin Kamat wrote:

> Check the return value of regulator_enable to silence the following
> warning:
> drivers/power/pm2301_charger.c:725:20: warning:
> ignoring return value of ‘regulator_enable’, declared with
> attribute warn_unused_result [-Wunused-result]
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
> Compile tested.
> Changes since v2:
> * removed redundant assignment to false.
> Changes since v1:
> * converted dev_err and return to dev_warn as suggested by Lee Jones.
> ---
>  drivers/power/pm2301_charger.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Looks good now.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
