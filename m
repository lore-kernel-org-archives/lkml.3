Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaDOKDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:03:37 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:57221 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaDOKDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:03:33 -0400
Date: Tue, 15 Apr 2014 11:03:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Matt Porter <mporter@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: bcm590xx: Fix modalias prefix
Message-ID: <20140415100327.GA27091@lee--X1>
References: <1396272676.7843.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396272676.7843.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a i2c driver, so uses i2c prefix in modalias.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/mfd/bcm590xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
