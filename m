Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbaBUNxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:53:20 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:64729 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbaBUNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:53:16 -0500
MIME-Version: 1.0
In-Reply-To: <1392984758-10127-1-git-send-email-k.kozlowski@samsung.com>
References: <1392984758-10127-1-git-send-email-k.kozlowski@samsung.com>
Date: Fri, 21 Feb 2014 19:23:14 +0530
Message-ID: <CAK9yfHwr8=T8yTFgtf1D_cBoQsY8NyAgs7VvpiED2BWtOjYmrw@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: max14577: Fix invalid return value on DT
 parse success
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 February 2014 17:42, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> This fixes bug introduced in 667a6b7a (regulator: max14577: Add missing
> of_node_put). The DTS parsing function returned number of matched
> regulators as success status which then was compared against 0 in probe.
>
> Result was a probe fail after successful parsing the DTS:
> max14577-regulator: probe of max14577-regulator failed with error 2
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Sachin Kamat <sachin.kamat@linaro.org>

Looks good.
Reviewed-by: Sachin Kamat <sachin.kamat@linaro.org>


-- 
With warm regards,
Sachin
