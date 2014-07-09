Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaGIPeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:34:20 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:63347 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603AbaGIPeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:34:16 -0400
Date: Wed, 9 Jul 2014 16:34:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: robh+dt@kernel.org, swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com
Subject: Re: [PATCH] Doc: mfd: as3722: Add details of optional missing
 property
Message-ID: <20140709153410.GK2635@lee--X1>
References: <1402297417-9338-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402297417-9338-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2014, Laxman Dewangan wrote:

> Add details of following properties which are used on driver but
> not documented on DT binding document.
> - ams,enable-internal-int-pullup
> - ams,enable-internal-i2c-pullup
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Reported-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/mfd/as3722.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)

Applied with Linus' Ack, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
