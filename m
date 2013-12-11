Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3LKJ3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:29:50 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:52563 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3LKJ3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:29:47 -0500
Date: Wed, 11 Dec 2013 09:29:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/8] mfd: ssbi: Mark match table const
Message-ID: <20131211092942.GF16780@lee--X1>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
 <1386718523-2587-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386718523-2587-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Stephen Boyd wrote:

> This is a read-only data structure.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/ssbi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

It certainly is.

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
