Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaDVHkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:40:01 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53103 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbaDVHjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:39:32 -0400
Date: Tue, 22 Apr 2014 08:39:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/3] arm: dts: add device_type="memory" for ste-ccu8540
Message-ID: <20140422073926.GC17657@lee--X1>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
 <1397756521-29387-2-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397756521-29387-2-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The current .dts for ste-ccu8540 lacks a 'device_type = "memory"' for
> its memory node, relying on an old ppc quirk in order to discover its
> memory. Add this, to permit that quirk to be made ppc only.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: devicetree@vger.kernel.org
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/ste-ccu8540.dts |    1 +
>  1 file changed, 1 insertion(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
