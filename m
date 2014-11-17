Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaKQKUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:20:53 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40010 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaKQKUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:20:51 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-6a-5469cbff5eaf
Message-id: <5469CBFB.8040805@samsung.com>
Date: Mon, 17 Nov 2014 11:20:43 +0100
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, lee.jones@linaro.org,
        broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 5/5] mfd: s2mps11: Add binding documentation for Samsung
 S2MPS13 PMIC
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-6-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1416184980-532-6-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xa7r/T2eGGCw6zmax5OJVdoupD5+w
	WVz/8pzVYv6Rc6wWfya0sllMuj+BxeL1C0OLs01v2C3ufz3KaPHtSgeTxeVdc9gsnk64yGZx
	upvV4uKKL0wOfB47Z91l99i0qpPN4861PWwe804GevRtWcXoMX3eTyaPz5vkAtijuGxSUnMy
	y1KL9O0SuDI2/t7AVPCSpeL8tKnMDYxNLF2MnBwSAiYSV84/YIewxSQu3FvP1sXIxSEksJRR
	4t+yWSwQzmcg58Q7ZpAqXgEticYFRxlBbBYBVYmtZw6B2WwCHhLTvveA1YgKREhcWTOHEaJe
	UOLH5Htgg0QEGhklni75BeYwC5xmlFi7YBkTSJWwQLTE/X+7wO4QEqiV+PHzN1g3p4CLxILd
	e4Fu4gBqUJeYMiUXJMwsIC+xec1b5gmMArOQ7JiFUDULSdUCRuZVjKKppckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGCGx83UH49JjVocYBTgYlXh4DxRlhgixJpYVV+YeYpTgYFYS4f18HCjEm5JY
	WZValB9fVJqTWnyIkYmDU6qB8bqWqmbiLb+2aZZHA1VeHll/mdczdJ5ihFqSnOhrnYSIXvtl
	Vu/aleO5PnPt7qtvtN52X1uyMX/7p47VNdVl17+d9xHT1Zh1au9BS7EN+4w1r/w+1MZa4cpS
	xdMoamWe88B11ZJ7olv+rw6conNy56s5Rza/WzSp9iC7snPwXpfX9zYnpHFcUWIpzkg01GIu
	Kk4EAJ/2Hnp7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.11.2014 01:43, Chanwoo Choi wrote:
> This patch adds the binding documentation for Samsung S2MPS13 PMIC
> which is similiar with existing S2MPS14 PMIC. S2MPS13 has the different number
> of regulators from S2MPS14 and RTC/Clock is the same with the S2MPS14.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/s2mps11.txt | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)

Looks good.

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

