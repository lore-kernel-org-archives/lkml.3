Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014AbaE2Iud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:50:33 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63068 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbaE2Iu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:50:29 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f626d000004b39-e9-5386f4d107a4
Content-transfer-encoding: 8BIT
Message-id: <1401353429.25628.8.camel@AMDC1943>
Subject: Re: [PATCH 1/4] mfd: sec-core: Add support for S2MPU02 device
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com
Date: Thu, 29 May 2014 10:50:29 +0200
In-reply-to: <1401275411-21947-2-git-send-email-cw00.choi@samsung.com>
References: <1401275411-21947-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xK7oXv7QFG9y9rWMx9eETNovrX56z
	WnSefcJscbbpDbvF/a9HGS2+Xelgsri8aw6bxe3GFWwWp7tZLS6u+MLkwOWxc9Zddo9NqzrZ
	PO5c28PmMe9koEffllWMHp83yQWwRXHZpKTmZJalFunbJXBlvJj+hL2gkbVi5uk25gbGv8xd
	jJwcEgImEjd2zYCyxSQu3FvP1sXIxSEksJRR4tzzK6wgCV4BQYkfk++xdDFycDALyEscuZQN
	EmYWUJeYNG8RWK+QwGdGiV0LjSDK9SX6exrB4sICbhKvVtwAs9kEjCU2L1/CBmKLCGhIzPx7
	hRFkF7PAPUaJlW+ngBWxCKhK9N58yARicwI135v7hxFigavE9/dT2SEOVZaYt/8Y0wRGgVlI
	zpuFcN4sJOctYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESB193MC49ZnWIUYCDUYmH
	9+bRtmAh1sSy4srcQ4wSHMxKIryfLgGFeFMSK6tSi/Lji0pzUosPMTJxcEo1MGo/8Hx9PqC1
	0vok98eHK0Qi3/utXSM8L6xbN/b22wdnXxZotzyebpn6KqvSLtjrOn/3/cXCzzrsjj+78Iml
	/PSZLw/z3BVOFeqfW3Ng1rmsX7rnNsX4zHr7fonOhSdmz6rOen4Lvh+6Wj/6jpnYttP8ixKX
	abmeuXFqjU259qdWOecll35MN7FSYinOSDTUYi4qTgQAFdBkiWECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-05-28 at 20:10 +0900, Chanwoo Choi wrote:
> Add support for Samsung S2MPU02 PMIC device to the MFD sec-core driver.
> The S2MPU02 device includes PMIC/RTC/Clock devices.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> 
> ---
> drivers/mfd/sec-core.c           | 19 +++++++++
>  drivers/mfd/sec-irq.c            | 88 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/samsung/core.h |  1 +
>  include/linux/mfd/samsung/irq.h  | 24 +++++++++++
>  4 files changed, 132 insertions(+)

Looks good!

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof




