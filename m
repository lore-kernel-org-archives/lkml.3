Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab3GKLGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:06:51 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56328 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3GKLGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:06:49 -0400
Date: Thu, 11 Jul 2013 12:06:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, sbkim73@samsung.com, broonie@kernel.org,
        lgirdwood@gmail.com, sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, sachin.kamat@linaro.org,
        yadi.brar01@gmail.com
Subject: Re: [v2 PATCH 6/6] mfd: s2mps11: Add device tree support
Message-ID: <20130711110641.GF25601@gmail.com>
References: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
 <1372510280-31931-7-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1372510280-31931-7-git-send-email-yadi.brar@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Jun 2013, Yadwinder Singh Brar wrote:

> This patch adds DT compatible string for s2mps11 and binding documentation.
> 
> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/s2mps11.txt |   89 +++++++++++++++++++++
>  drivers/mfd/sec-core.c                            |    3 +
>  2 files changed, 92 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/s2mps11.txt

Applied with Mark's RB.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
