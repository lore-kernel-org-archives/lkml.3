Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaIVIfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:35:06 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:51990 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaIVIfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:35:04 -0400
Message-ID: <541FDF35.6010401@gmail.com>
Date: Mon, 22 Sep 2014 10:35:01 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: kgene.kim@samsung.com, s.nawrocki@samsung.com, mturquette@linaro.org,
        naushad@samsung.com
Subject: Re: [PATCH] clk: samsung: exynos3250: fix width field of mout_mmc0/1
References: <1409918081-2464-1-git-send-email-pankaj.dubey@samsung.com> <540EEF0B.3040202@samsung.com>
In-Reply-To: <540EEF0B.3040202@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.09.2014 14:14, Krzysztof Kozlowski wrote:
> On 05.09.2014 13:54, Pankaj Dubey wrote:
>> As per Exynos3250 user manual mmc0/1 mux selection has 4 bit wide.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   drivers/clk/samsung/clk-exynos3250.c |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Applied for next.

Best regards,
Tomasz
