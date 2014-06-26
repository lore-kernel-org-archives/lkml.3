Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbaFZLvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:51:49 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:45868 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261AbaFZLvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:51:47 -0400
MIME-Version: 1.0
In-Reply-To: <1403783163-28638-1-git-send-email-k.kozlowski@samsung.com>
References: <1403783163-28638-1-git-send-email-k.kozlowski@samsung.com>
Date: Thu, 26 Jun 2014 17:21:45 +0530
X-Google-Sender-Auth: dPDED7fZTMZBaoL472jauT5Wh-M
Message-ID: <CAK5sBcGdYZRdOK7nDhGFn=TTsFmmp2ReajA+0o5w9u6WxSDR9A@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: EXYNOS: Do not calculate boot address twice
From: Sachin Kamat <sachin.kamat@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On Thu, Jun 26, 2014 at 5:16 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> Commit b3205dea8fbf ("ARM: EXYNOS: Map SYSRAM through generic DT
> bindings") introduced local variable boot_reg where boot address from
> cpu_boot_reg() call is stored. Re-use it instead calling cpu_boot_reg()
> again.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---

Thanks for the patch.
Reviewed-by: Sachin Kamat <sachin.kamat@samsung.com>

Regards,
Sachin.
