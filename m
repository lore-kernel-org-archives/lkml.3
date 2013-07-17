Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3GQLXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:23:36 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44727 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3GQLXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:23:35 -0400
Date: Wed, 17 Jul 2013 12:23:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sbkim73@samsung.com, sameo@linux.intel.com, mturquette@linaro.org,
        broonie@kernel.org, yadi.brar01@gmail.com
Subject: Re: [PATCH 2/3] mfd: sec: Add clock cell for s2mps11
Message-ID: <20130717112329.GC3336@laptop>
References: <1373197462-4033-1-git-send-email-yadi.brar@samsung.com>
 <1373197462-4033-3-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373197462-4033-3-git-send-email-yadi.brar@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Jul 2013, Yadwinder Singh Brar wrote:

> This patch adds clock to list of mfd cells for s2mps11 and DT documentation
> for clock part.
> 
> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/s2mps11.txt |   20 ++++++++++++++++++++
>  drivers/mfd/sec-core.c                            |    4 +++-
>  2 files changed, 23 insertions(+), 1 deletions(-)

For drivers/mfd/sec-core.c:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
