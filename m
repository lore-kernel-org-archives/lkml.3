Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab3HGRk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:40:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42941 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab3HGRk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:40:56 -0400
Date: Wed, 7 Aug 2013 10:40:53 -0700
From: David Brown <davidb@codeaurora.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] ARM: msm: fix compilation error in gpiomux
Message-ID: <20130807174053.GA17551@codeaurora.org>
References: <1375857279-18082-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375857279-18082-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 08:34:39AM +0200, Krzysztof Kozlowski wrote:
>Fix compilation error in gpiomux (CONFIG_MSM_GPIOMUX=y):
>arch/arm/mach-msm/gpiomux.c:24:13: error: static declaration of
>	‘__msm_gpiomux_write’ follows non-static declaration
>arch/arm/mach-msm/gpiomux.h:85:6: note: previous declaration of
>	‘__msm_gpiomux_write’ was here
>
>Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Thanks, I'll pull this in.

  <https://patchwork.kernel.org/patch/2839921/>

Daivd

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
