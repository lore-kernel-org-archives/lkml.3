Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab3DDKFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:05:48 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:43884 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493Ab3DDKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:05:45 -0400
Date: Thu, 4 Apr 2013 11:05:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/2] mfd: db8500-prcmu: Return early if the TCPM cannot
 be located
Message-ID: <20130404100539.GA8921@gmail.com>
References: <1365067877-29459-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1365067877-29459-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Apr 2013, Lee Jones wrote:

> Currently we check to see if we obtained the Tightly Coupled Program
> Memory (TCPM) base and only execute the code within the check if we
> have it. It's more traditional to return early if we don't have it.
> This way we can flatten most of the function's code down to a single
> tab spacing.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c |   40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)

Withdrawn.

I'll resubmit.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
