Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaCMMvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:51:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46752 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaCMMvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:51:45 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-b9-5321a9dfc613
Message-id: <5321A9DD.2060901@samsung.com>
Date: Thu, 13 Mar 2014 13:51:41 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 3/3] Documentation: mfd: s2mps11: Describe S5M8767 and
 S2MPS14 clocks
References: <1394703425-6462-1-git-send-email-k.kozlowski@samsung.com>
 <1394703425-6462-4-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1394703425-6462-4-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t/xa7r3VyoGG7zcKm6xccZ6Vov5R86x
	WvS/Wchqce7VSkaL1y8MLc42vWG3uP/1KKPFpsfXWC0u75rDZjHj/D4mi7VH7rJbLL1+kcni
	6YSLbBYTpq9lsWjde4Td4uSfXkaL092sFhdXfGGyaP+7l81izvR3TA4iHmvmrWH0uNzXy+Sx
	cvkXNo9NqzrZPO5c28PmMe9koMfmJfUefVtWMXp83iQXwBnFZZOSmpNZllqkb5fAlbGxYxV7
	wSnWiv19K5kaGO+wdDFyckgImEic2XOQGcIWk7hwbz1bFyMXh5DAUkaJ7z2vmCCcz4wSF/df
	ZwSp4hXQkvg8dyNYB4uAqsS/u8tZQWw2ATWJzw2P2EBsUYEIibkTN7NB1AtK/Jh8jwVkkIjA
	FiaJritXGUEcZoGvzBJ/ls4CqxIWiJNo+voAal0zo8TX99fA1nEKuEu8/jmRCcRmFrCWWDlp
	GyOELS+xec1b5gmMArOQbJmFpGwWkrIFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MULi
	8csOxsXHrA4xCnAwKvHwrliuECzEmlhWXJl7iFGCg1lJhLdwkWKwEG9KYmVValF+fFFpTmrx
	IUYmDk6pBsZpYStC1kToiTV2T07nUGF/vtNS2ljTw/KYzPb3qxK0+7Wqpu3XXOh7vM3H7ElY
	govOuQ8cce7qHGsLpe1XR9U9m26bEG8dv8xAdOnc9JAiobUhmWVxHVzCvdy8RXqKr1d7HZa4
	luqvMMNrtsCbdxaLH039uWXmjmcMjM+ef09yvLZ839xtn5VYijMSDbWYi4oTAVGTCnClAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 13.03.2014 10:37, Krzysztof Kozlowski wrote:
> Add bindings documentation for clocks on S5M8767 and S2MPS14 devices.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: devicetree@vger.kernel.org
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> ---
>   Documentation/devicetree/bindings/mfd/s2mps11.txt |   24 +++++++++++++--------
>   1 file changed, 15 insertions(+), 9 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
