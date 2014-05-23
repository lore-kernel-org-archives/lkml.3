Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaEWWv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:51:56 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55844 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaEWWvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:51:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1400671381-14792-1-git-send-email-k.kozlowski@samsung.com>
Cc: "Lee Jones" <lee.jones@linaro.org>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        "Tomasz Figa" <t.figa@samsung.com>,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>
References: <1400671381-14792-1-git-send-email-k.kozlowski@samsung.com>
Message-ID: <20140523225143.23136.5825@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v4 0/3] clk: s2mps11: Fixes and add support for S2MPS14 clocks
Date: Fri, 23 May 2014 15:51:43 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Krzysztof Kozlowski (2014-05-21 04:22:58)
> Hi,
> 
> 
> This is actually a resend of previous patches, rebased on latest
> 3.15-rc5. There are no changes, beside rebasing.
> 
> The first two fixes were posted previously as separate patches and they
> didn't get review [1]. I am attaching them here.
> The last patch adds support for S2MPS14 device and already was
> reviewed/acked [2].
> 
> Mike, could you pick them up or should they go through MFD tree?

Applied to clk-next.

Regards,
Mike

> 
> 
> [1] https://lkml.org/lkml/2014/4/7/42
> [2] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/28039/focus=310279
> 
> 
> Changes since v3:
> =================
> 1. Add Mike's acked-by (see [2]).
> 2. Rebase patch 3/3 on the fixes (patches 1 and 2).
> 3. Rebase on v3.15-rc5-157-g60b5f90d0fac
> 
> Changes since v2:
> =================
> 1. Patch 2/3: Remove MFD cells of_compatible which aren't used by child
>    drivers and are not documented.
> 2. Added Tomasz's Review-by.
> 
> Changes since v1:
> =================
> 1. Patch 1/3: Update driver description in Kconfig.
> 2. Patch 2/3: Add of_compatible to all MFD cells.
> 3. Add Yadwinder's Review-by.
> 
> 
> Best regards,
> Krzysztof
> 
> 
> Krzysztof Kozlowski (3):
>   clk: s2mps11: Add missing of_node_put and of_clk_del_provider
>   clk: s2mps11: Remove useless check for clk_table
>   clk: s2mps11: Add support for S2MPS14 clocks
> 
>  drivers/clk/Kconfig       |  8 ++---
>  drivers/clk/clk-s2mps11.c | 88 +++++++++++++++++++++++++++++++++--------------
>  2 files changed, 66 insertions(+), 30 deletions(-)
> 
> -- 
> 1.9.1
> 
