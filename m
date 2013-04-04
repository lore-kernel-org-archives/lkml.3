Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab3DDKGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:06:30 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:52186 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804Ab3DDKG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:06:28 -0400
Date: Thu, 4 Apr 2013 11:06:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/2] mfd: db8500-prcmu: Support platform dependant device
 selection
Message-ID: <20130404100623.GB8921@gmail.com>
References: <1365067877-29459-1-git-send-email-lee.jones@linaro.org>
 <1365067877-29459-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1365067877-29459-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Apr 2013, Lee Jones wrote:

> The main aim for this cycle is to have the u8540 booting to a
> console. However, the u8540 doesn't support all of the u8500
> platform devices yet. After this stage is complete we can then
> fill in the inadequacies, such as specific clock support at a
> later date. To achieve this we're placing devices supported by
> all platforms into a common device structure and the remaining
> ones into a platform specific one.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c |   46 +++++++++++++++++++++++++++++---------------
>  1 file changed, 30 insertions(+), 16 deletions(-)

Withdrawn.

I'll resubmit.

Sorry for the churn.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
