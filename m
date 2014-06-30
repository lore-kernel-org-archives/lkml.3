Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaF3QVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:21:10 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36632 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbaF3QVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:21:08 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ba-53b18e6d50ba
Message-id: <53B18E52.1060906@samsung.com>
Date: Mon, 30 Jun 2014 18:20:34 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH v5 3/5] ARM: EXYNOS: Move "mach/map.h" inclusion from
 regs-pmu.h to platsmp.c
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
 <1403705032-14835-4-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1403705032-14835-4-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xK7q5fRuDDc5dVLBYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWq6FjGaHHz2XYmB26PluYeNo/N
	S+o9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK6Pp1XzGgjbWiqtHt7E3MHawdDFyckgImEic
	WbGSDcIWk7hwbz2QzcUhJLCUUeLvvvMsEM5nRomvez6wg1TxCmhJXPx0hRHEZhFQldj09wuY
	zSagJvG54RHYJH6gmjVN14GaOThEBSIkHl8QgmgVlPgx+R7YTBGBaYwSFy/dZgdxmAWWMErs
	mXEKbJCwQLLEvq5LTCC2kEA7o8T8adYgNqeAp8T3rU1gZzML6Ejsb53GBmHLS2xe85Z5AqPg
	LCRLZiEpm4WkbAEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkMj4soNx8TGrQ4wCHIxK
	PLyNKzYEC7EmlhVX5h5ilOBgVhLhvemzMViINyWxsiq1KD++qDQntfgQIxMHp1QDo2NtTgnH
	bv7V8481bz4UrOmzxfNSVueMF3EHrp+Ml7ua56aZu/2sxFH5p+qtr6/d62bIidqYodu8vPX8
	opLr6fab2gtPTNrxyv6/kdTCmpUzdaf39nzTymd+t5RV9TlHZkfEqqLNpufsS+ceYKvLfn5j
	zYf+4KsskyXkXJU8MpZlvXt9LrxxnRJLcUaioRZzUXEiAL1FkkZqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 25.06.2014 16:03, Pankaj Dubey wrote:
> As we have removed static mappings from "regs-pmu.h" it does not
> need map.h anymore. But "platsmp.c" needed this and till now it
> got included indirectly. So lets move header inclusion of
> "mach/map.h" from "regs-pmu.h" to "platsmp.c".
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/mach-exynos/platsmp.c  |    2 ++
>  arch/arm/mach-exynos/regs-pmu.h |    2 --
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 

IMHO this could be squashed with previous patch.

Best regards,
Tomasz
