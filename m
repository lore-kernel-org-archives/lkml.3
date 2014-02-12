Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaBLKBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:01:37 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:65420 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaBLKBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:01:34 -0500
MIME-Version: 1.0
In-Reply-To: <1392123837-5517-8-git-send-email-k.kozlowski@samsung.com>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
	<1392123837-5517-8-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 12 Feb 2014 15:31:33 +0530
Message-ID: <CAKew6eV4t-CybRe0h3jVTFH5xZvj5+XLVTKdNyWyYNby_jMnZQ@mail.gmail.com>
Subject: Re: [PATCH 07/14] regulator: s2mps11: Choose number of supported
 regulators during probe
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


>
> +       dev_type = platform_get_device_id(pdev)->driver_data;
> +       switch (dev_type) {
> +       case S2MPS11X:
> +               s2mps11->rdev_num = ARRAY_SIZE(s2mps11_regulators);
> +               regulators = s2mps11_regulators;

How about creating and passing copy of s2mps11_regulators at runtime
and making s2mps11_regulators __initdata ?

Regards,
Yadwinder
