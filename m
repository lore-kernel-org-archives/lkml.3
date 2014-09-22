Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaIVIgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:36:06 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41262 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaIVIgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:36:04 -0400
Message-ID: <541FDF6F.6090903@gmail.com>
Date: Mon, 22 Sep 2014 10:35:59 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: kgene.kim@samsung.com, s.nawrocki@samsung.com, mturquette@linaro.org,
        naushad@samsung.com
Subject: Re: [PATCH] clk: samsung: exynos3250: fix mout_cam_blk parent list
References: <1410008613-20861-1-git-send-email-pankaj.dubey@samsung.com> <540EF177.8090005@samsung.com>
In-Reply-To: <540EF177.8090005@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.09.2014 14:24, Krzysztof Kozłowski wrote:
> On 06.09.2014 15:03, Pankaj Dubey wrote:
>> As per user manual of Exynos3250 SRC_CAM can select
>> div_cam_blk_320 if it's value is 0xC, so placing
>> div_cam_blk_320 at proper index in parent list of mout_cam_blk.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   drivers/clk/samsung/clk-exynos3250.c |    1 +
>>   1 file changed, 1 insertion(+)
> 
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Applied for next.

Best regards,
Tomasz
