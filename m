Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaAZU75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 15:59:57 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:57559 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaAZU74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 15:59:56 -0500
Message-ID: <52E57744.5030807@gmail.com>
Date: Sun, 26 Jan 2014 21:59:48 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mike Turquette <mturquette@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Andrzej Hajda <a.hajda@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the clk tree with the arm-soc tree
References: <20140113160630.cf720268510f5e0931c24284@canb.auug.org.au>
In-Reply-To: <20140113160630.cf720268510f5e0931c24284@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 13.01.2014 06:06, Stephen Rothwell wrote:
> Hi Mike,
>
> Today's linux-next merge of the clk tree got a conflict in
> drivers/clk/samsung/clk-exynos4.c between commit 86576fbe201b ("clk:
> samsung: exynos4: Fix definition of div_mmc_pre4 divider") from the
> arm-soc tree and commit 2d7382375054 ("clk: exynos4: replace clock ID
> private enums with IDs from DT header") from the clk tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

It seems like somehow this fix-up has been lost in action and the 
conflict ended up being merged incorrectly in linux-next. Could you take 
a look?

Best regards,
Tomasz
