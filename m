Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab3JRKtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 06:49:43 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:65532 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab3JRKtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 06:49:42 -0400
Date: Fri, 18 Oct 2013 11:49:34 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5 v2] mfd: tc3589x: Detect the precise version
Message-ID: <20131018104934.GS19112@lee--X1>
References: <1382089905-20730-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382089905-20730-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013, Linus Walleij wrote:

> Instead of detecting the "tc3589x" and hard-coding the number of
> GPIO pins to 24, encode all the possible subtypes and set the
> number of GPIO pins from the type.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Compress the switch tree to the two variables we currently
>   have to deal with.

So you chose my least favourite alternative. ;)

> ---
>  drivers/mfd/tc3589x.c | 37 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 35 insertions(+), 2 deletions(-)

Anyway... patch applied.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
