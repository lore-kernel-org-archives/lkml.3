Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaIVIfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:35:45 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46354 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaIVIfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:35:42 -0400
Message-ID: <541FDF5A.5060709@gmail.com>
Date: Mon, 22 Sep 2014 10:35:38 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski.k.linux@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: kgene.kim@samsung.com, s.nawrocki@samsung.com, mturquette@linaro.org,
        naushad@samsung.com
Subject: Re: [PATCH] clk: samsung: exynos3250: fix width and shift of div_spi0_isp
 clock
References: <1410263697-768-1-git-send-email-pankaj.dubey@samsung.com> <540EEF33.9010207@gmail.com>
In-Reply-To: <540EEF33.9010207@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.09.2014 14:14, Krzysztof Kozlowski wrote:
> On 09.09.2014 13:54, Pankaj Dubey wrote:
>> Update shift and width field of div_spi0_isp clock as per Exynos3250
>> user manual.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   drivers/clk/samsung/clk-exynos3250.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Applied for next.

Best regards,
Tomasz
