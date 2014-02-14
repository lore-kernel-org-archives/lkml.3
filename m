Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaBNLbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:31:22 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:42843 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaBNLbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:31:20 -0500
Date: Fri, 14 Feb 2014 11:31:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: wm8400-core: Remove unnecessary goto
Message-ID: <20140214113115.GF9462@lee--X1>
References: <1392371465-25294-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392371465-25294-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Return directly to avoid redundant lines of code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
> Changes since v1:
> Changed (wm8400 == NULL) -> (!wm8400)
> ---
>  drivers/mfd/wm8400-core.c |   22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)

Nice little clean-up. Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
