Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbaGIUQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:16:52 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48956 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaGIUQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:16:50 -0400
Message-ID: <53BDA31D.40502@gmail.com>
Date: Wed, 09 Jul 2014 22:16:29 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, rabin@rab.in,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [RFC v2 0/5] Per-user clock constraints
References: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomeu,

On 03.07.2014 16:38, Tomeu Vizoso wrote:
> Hello,
> 
> here is another round for commenting, not very different from the first one.
> 
> Something I forgot to mention before is that the function rename was performed
> by the scripts in:
> 
> http://cgit.collabora.com/git/user/tomeu/linux.git/commit/?h=clk-refactoring-4&id=0e983e28864229f2cd525f87d59e034c4876b233
> 
> As before, I have only checked that drivers/clk/ builds with allyesconfig, and
> that a kernel can be built for tegra_defconfig.

This is quite an interesting series. I have reviewed two of five patches
and have plans to look at remaining ones, however here are few general
issues I'd like to raise:

- somehow I don't see patch 2/5 on LAKML. Too big?

- I see the series changing particular clock drivers. A good practice
would be to Cc respective driver maintainers to take a look at those
changes.

- please make sure that all the patches don't have checkpatch errors or
significant warnings.

Will try (myself or by asking someone else) to do some testing on
Samsung platforms.

Best regards,
Tomasz
