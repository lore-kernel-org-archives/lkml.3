Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab3IFHFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 03:05:40 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:50686 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3IFHFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 03:05:35 -0400
Date: Fri, 6 Sep 2013 08:05:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, anton@enomsg.org, dwmw2@infradead.org
Subject: Re: [PATCH v2 2/4] ab8500-charger: Remove redundant break
Message-ID: <20130906070530.GD32654@lee--X1>
References: <1378448873-4430-1-git-send-email-sachin.kamat@linaro.org>
 <1378448873-4430-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378448873-4430-2-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Sep 2013, Sachin Kamat wrote:

> Each of the if-else blocks has a break statement.
> Remove the additional one which is unreachable.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> No changes since v1.
> ---
>  drivers/power/ab8500_charger.c |    1 -
>  1 file changed, 1 deletion(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
