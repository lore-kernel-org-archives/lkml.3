Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab3AXH0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 02:26:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41743 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3AXH0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 02:26:49 -0500
Date: Thu, 24 Jan 2013 08:26:47 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: Re: [PATCH V2 0/4] i2c: s3c2410: Add devm_* apis and cleanup
Message-ID: <20130124072647.GF8364@nekote.pengutronix.de>
References: <1353660115-9710-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353660115-9710-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 02:11:51PM +0530, Tushar Behera wrote:
> This patchset cleans up the probe function of i2c-s3c2410 driver.
> These have been tested on Exynos4210 based Origen board.
> 
> Changes since V1:
>   * devm_request_mem_region and devm_ioremap calls were replaced by
> devm_request_and_ioremap() call.
>   * All devm_* related modifications (earlier patches 2-5) were merged
> to a single patch.
> 

Patch series looks good. Can you rebase to 3.8-rc4?

