Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaKFXTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:19:54 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:43443 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaKFXTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:19:35 -0500
Message-ID: <545C01FF.3090101@collabora.co.uk>
Date: Fri, 07 Nov 2014 00:19:27 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 3/3] mfd: max77686/802: Remove support for board files
References: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com> <1415180871-25293-4-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1415180871-25293-4-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 10:47 AM, Krzysztof Kozlowski wrote:
> The driver is used only on Exynos based boards with DTS support.
> After removal of board file support from max77686 and max77802 regulator
> drivers, the MFD driver can be converted to DTS-only version. This
> simplifies a little the code:

Acked-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier

