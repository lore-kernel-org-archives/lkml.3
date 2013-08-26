Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3HZJnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 05:43:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60501 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab3HZJnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 05:43:45 -0400
Message-ID: <521B2346.10307@ti.com>
Date: Mon, 26 Aug 2013 15:13:34 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>,
        "'devicetree'" <devicetree@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>, "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH V7 0/3] Generic PHY driver for the Exynos SoC DP PHY
References: <003e01cea23a$03aac850$0b0058f0$%han@samsung.com>
In-Reply-To: <003e01cea23a$03aac850$0b0058f0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 August 2013 02:25 PM, Jingoo Han wrote:
> This patch series adds a simple driver for the Samsung Exynos SoC
> series DP transmitter PHY, using the generic PHY framework [1].
> Previously the DP PHY used an internal DT node to control the PHY
> power enable bit.
> 
> These patches was tested on Exynos5250.
> 
> This PATCH v7 follows:
>  * PATCH v6, sent on July, 9th 2013
>  * PATCH v5, sent on July, 8th 2013
>  * PATCH v4, sent on July, 2nd 2013
>  * PATCH v3, sent on July, 1st 2013
>  * PATCH v2, sent on June, 28th 2013
>  * PATCH v1, sent on June, 28th 2013
> 
> Changes from v6:
>   * Re-based on git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git
> 
> Changes from v5:
>   * Re-based on git://gitorious.org/linuxphy/linuxphy.git
> 
> Changes from v4:
>   * Marked original bindings as deprecated in 'exynos_dp.txt'
>   * Fixed typo of commit message.
>   * Added Tomasz Figa's Reviewed-by.
> 
> Changes from v3:
>   * Added OF dependancy.
>   * Removed redundant local variable 'void __iomem *addr'.
>   * Removed unnecessary dev_set_drvdata().
>   * Added a patch that remove non-DT support for Exynos
>     Display Port driver.
>   * Removed unnecessary 'struct exynos_dp_platdata'.
>   * Kept supporting the original bindings for DT compatibility.
> 
> Changes from v2:
>   * Removed redundant spinlock
>   * Removed 'struct phy' from 'struct exynos_dp_video_phy'
>   * Updated 'samsung-phy.txt', instead of creating
>     'samsung,exynos5250-dp-video-phy.txt'.
>   * Removed unnecessary additional specifier from 'phys'
>     DT property.
>   * Added 'phys', 'phy-names' properties to 'exynos_dp.txt' file.
>   * Added Felipe Balbi's Acked-by.
> 
> Changes from v1:
>   * Replaced exynos_dp_video_phy_xlate() with of_phy_simple_xlate(),
>     as Kishon Vijay Abraham I guided.
>   * Set the value of phy-cells as 0, because the phy_provider implements
>     only one PHY.
>   * Removed unnecessary header include.
>   * Added '#ifdef CONFIG_OF' and of_match_ptr macro.
> 
> This series depends on the generic PHY framework [1]. These patches
> refer to Sylwester Nawrocki's patches about Exynos MIPI [2].
> 
> [1] http://lwn.net/Articles/564188/
> [2] http://www.spinics.net/lists/linux-samsung-soc/msg20098.html
> 
> Jingoo Han (3):
>   phy: Add driver for Exynos DP PHY
>   video: exynos_dp: remove non-DT support for Exynos Display Port
>   video: exynos_dp: Use the generic PHY driver

FWIW,
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
