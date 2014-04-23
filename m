Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaDWOTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:19:10 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:50109 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaDWOTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:19:08 -0400
Date: Wed, 23 Apr 2014 15:19:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Bill Richardson <wfrichar@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: cros_ec: cleanup: cros_ec.c is GPL licensed, like
 all the others.
Message-ID: <20140423141901.GD6264@lee--X1>
References: <1397763137-20552-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397763137-20552-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Bill Richardson <wfrichar@chromium.org>
> 
> This module has always been GPL licensed. It was just missing the explicit
> declaration to avoid tainting the kernel.
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mfd/cros_ec.c | 3 +++
>  1 file changed, 3 insertions(+)

Applied, thanks.


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
