Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110AbaEFGpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:45:45 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:62485 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838AbaEFGpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:45:43 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.131.110]
In-Reply-To: <1399358258-21536-1-git-send-email-k.kozlowski@samsung.com>
References: <1399358258-21536-1-git-send-email-k.kozlowski@samsung.com>
Date: Tue, 6 May 2014 14:45:42 +0800
Message-ID: <CAFRkauBWXVqLkY-tgYqx2urDK32n=xf-sHjzvY=UfCyB6+4VPA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] regulator: s2mps11: Fix accidental enable of buck6
 ramp delay
From: Axel Lin <axel.lin@ingics.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-06 14:37 GMT+08:00 Krzysztof Kozlowski <k.kozlowski@samsung.com>:
> S2MPS11 supports enabling/disabling ramp delay only for buck[2346].
> Other bucks have ramp delay enabled always.
>
> However the bit shift for enabling buck6 ramp delay in register is equal
> to 0. When ramp delay was set for the bucks unsupporting enable/disable
> (buck[15789] and buck10), the ramp delay for buck6 was also enabled.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Fixes: b96244fad953 ("regulator: s2mps11: Don't check enable_shift before setting enable ramp rate")

For this serial,
Reviewed-by: Axel Lin <axel.lin@ingics.com>
