Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab3KZAId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:08:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63672 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3KZAIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:08:30 -0500
Date: Mon, 25 Nov 2013 16:06:08 -0800
From: Olof Johansson <olof@lixom.net>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gnurou@gmail.com
Subject: Re: [PATCH v11 7/7] ARM: tegra: support Trusted Foundations by
 default
Message-ID: <20131126000608.GA21634@quad.lixom.net>
References: <1385274652-16415-1-git-send-email-acourbot@nvidia.com>
 <1385274652-16415-8-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385274652-16415-8-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 03:30:52PM +0900, Alexandre Courbot wrote:
> Support for Trusted Foundations is light and allows the kernel to run on
> a wider range of devices, so enable it by default.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> ---
>  arch/arm/configs/tegra_defconfig | 1 +
>  1 file changed, 1 insertion(+)

I think we want this enabled on multi_v7_defconfig too? Send a separate
patch for that once this is merged though.


-Olof
