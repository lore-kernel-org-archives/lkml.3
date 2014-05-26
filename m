Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaEZIkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:40:23 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62198 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaEZIkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:40:21 -0400
MIME-Version: 1.0
In-Reply-To: <1401092806-25664-1-git-send-email-k.kozlowski@samsung.com>
References: <1401092806-25664-1-git-send-email-k.kozlowski@samsung.com>
Date: Mon, 26 May 2014 14:10:20 +0530
Message-ID: <CAK9yfHw6icm=KizFi0O2AHzDEk9dzKpkqWSDdCei5NcEwS7bMA@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: s2mpa01: Use correct register for buck1
 ramp delay
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Axel Lin <axel.lin@ingics.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 May 2014 13:56, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> Fix the register for ramp delay of buck1 regulator. Buck1 and buck6
> share the field (offset 4) in ramp delay register S2MPA01_REG_RAMP2.
>
> The driver used the same register and field for ramp delay of buck3 and
> buck1. This lead to updating of ramp delay of buck3 when setting buck1
> and actually the ramp delay of buck1 was never set.
>
> Cc: <stable@vger.kernel.org>
> Fixes: f18792714608 ("regulator: Add support for S2MPA01 regulator")
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Sachin Kamat <sachin.kamat@linaro.org>

-- 
With warm regards,
Sachin
