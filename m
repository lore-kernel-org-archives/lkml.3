Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936386Ab3DKBT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 21:19:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48144 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762769Ab3DKBT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 21:19:27 -0400
Message-ID: <51660F85.4000105@ti.com>
Date: Wed, 10 Apr 2013 21:19:01 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, <eduardo.valentin@ti.com>
Subject: Re: [PATCH 14/30] thermal/exynos: remove unnecessary header inclusions
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <1365638712-1028578-15-git-send-email-arnd@arndb.de>
In-Reply-To: <1365638712-1028578-15-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rui, Arnd,

As agreed in [1], I will be helping on the thermal maintenance.

On 10-04-2013 20:04, Arnd Bergmann wrote:
> In multiplatform configurations, we cannot include headers
> provided by only the exynos platform. Fortunately a number
> of drivers that include those headers do not actually need
> them, so we can just remove the inclusions.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-pm@vger.kernel.org
> Cc: Zhang Rui <rui.zhang@intel.com>

This patch looks good to me.

You can add my:
Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>


[1] - http://marc.info/?l=linux-pm&m=136560509922173&w=2
