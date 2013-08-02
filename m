Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3HBKw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:52:29 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:54317 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759348Ab3HBKJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:19 -0400
Date: Fri, 2 Aug 2013 11:09:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH V2] mfd: menelaus: use NULL instead of 0
Message-ID: <20130802100913.GA17368@lee--X1>
References: <000801ce8f45$aa4dbda0$fee938e0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000801ce8f45$aa4dbda0$fee938e0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Aug 2013, Jingoo Han wrote:

> 'mmc_callback_data' and 'vtg' are pointers.
> Fix the following sparse warning:
> 
> drivers/mfd/menelaus.c:445:43: warning: Using plain integer as NULL pointer
> drivers/mfd/menelaus.c:469:20: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/menelaus.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
