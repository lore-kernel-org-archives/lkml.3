Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab3JQQLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:11:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29048 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569Ab3JQQLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:11:03 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-5a-52600c1541ee
Message-id: <52600C12.3000606@samsung.com>
Date: Thu, 17 Oct 2013 18:10:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] spi/s3c64xx: Add missing pm_runtime_set_active() call in
 probe()
References: <1382026006-15544-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1382026006-15544-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xq7qiPAlBBq9/8FpMWneAyWLqwyds
	Fq9fGFr0LrjKZnG26Q27xabH11gtLu+aw2Yx4/w+JovGjzfZHTg9/q56weyxaVUnm8fmJfUe
	fVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlTHx1H72gmvMFR++tbI0MPYwdzFyckgImEj8vt3D
	DmGLSVy4t54NxBYSWMooce6lVhcjF5D9iVFi16KDrCAJXgEtibMvu5lAbBYBVYlvk7eB2WwC
	hhK9R/sYQWxRgTCJo00/oeoFJX5MvscCMkhEYDajxNQ/axhBHGaBzYwSE06dAlsnLBAu0dp2
	hAVitbvEo4PTwCZxCnhIXL//Huw8ZgEdif2t09ggbHmJzWveMk9gFJiFZMksJGWzkJQtYGRe
	xSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRES+F92MC4+ZnWIUYCDUYmH98C3+CAh1sSy4src
	Q4wSHMxKIrxxXAlBQrwpiZVVqUX58UWlOanFhxiZODilGhgZi2Ma+Z6+PxIc6rtq9YxjZd/V
	jKbdMa47ZtPUOfE13+ua1Ynnl1nYfC/+en3jtD2b36+73WDGVCm0+v7Z/zLTE6Z/YZ4feF7h
	KHMow7Lyibs6mNJm5r1M26RwY0qU3KMzpqZyrLO6nu/yninJ7+2imPd96rQtT1x/scifCO9a
	s29r8X5h4T26SizFGYmGWsxFxYkAyDGiHVoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/13 18:06, Krzysztof Kozlowski wrote:
> Mark device as PM runtime active during initialization to reflect
> actual device power/clocks state. This reduces the enable count for SPI
> bus controller gate clock so it can be disabled when the bus controller
> is not used.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
