Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab3HWRyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:54:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45398 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab3HWRyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:54:22 -0400
Message-ID: <5217A1A7.6080305@ti.com>
Date: Fri, 23 Aug 2013 23:23:43 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH v3 1/7] gpio: davinci: coding style correction
References: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com> <1376803143-13738-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1376803143-13738-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prabhakar,

On 8/18/2013 10:48 AM, Lad, Prabhakar wrote:
> From: Philip Avinash <avinashphilip@ti.com>
> 
> Make some minor coding style fixes. Use proper multi-line
> commenting style, arrange include files alphabetically and
> use a macro for register offset.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> [nsekhar@ti.com: dropped changes which were considered
> churn - line break fixes and variable name changes]
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Queuing this for v3.12 through DaVinci tree (since there are dependent
mach-davinci patches). That said, its late for v3.12 and I cannot say if
ARM SoC team will take it.

Thanks,
Sekhar
