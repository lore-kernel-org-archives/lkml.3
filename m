Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3JRMsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:48:43 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:36592 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3JRMsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:48:42 -0400
Date: Fri, 18 Oct 2013 13:48:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, "SangYoung, Son" <hello.son@samsung.com>
Subject: Re: [PATCH 1/1] mfd: max77693: Include linux/of.h header
Message-ID: <20131018124835.GB19112@lee--X1>
References: <1382092917-31252-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382092917-31252-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013, Sachin Kamat wrote:

> 'of_match_ptr' is defined in linux/of.h. Include it explicitly to
> avoid build breakage in the future.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: SangYoung, Son <hello.son@samsung.com>
> ---
>  drivers/mfd/max77693.c |    1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
