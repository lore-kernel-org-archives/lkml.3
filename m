Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3H3IXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:23:11 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:56380 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab3H3IXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:23:08 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Martin <Dave.Martin@arm.com>, gnurou@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] ARM: tegra: support for Trusted Foundations
Date: Fri, 30 Aug 2013 10:23:03 +0200
Message-ID: <13779002.NFLbqBjPSE@flatron>
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-Reply-To: <1377770268-14014-1-git-send-email-acourbot@nvidia.com>
References: <1377770268-14014-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Thursday 29 of August 2013 18:57:43 Alexandre Courbot wrote:
> New version revised according to comments received for v3. Hopefully
> it will be good enough to be merged.
> 
> Changes since v3:
> - Added of_register_trusted_foundations() function to avoid duplicate
>   device tree parsing code in arch files
> - Added ability to initialize Trusted Foundations through platform data
> - Changed TF version number to integers
> - Refactored Kconfig menu for more clarity

Except some minor comments to patch 1/5, the series looks good to me.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

