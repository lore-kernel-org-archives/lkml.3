Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3GQOaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:30:24 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35520 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3GQOaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:30:19 -0400
MIME-Version: 1.0
In-Reply-To: <1374058786-16603-2-git-send-email-broonie@kernel.org>
References: <1374058786-16603-1-git-send-email-broonie@kernel.org>
	<1374058786-16603-2-git-send-email-broonie@kernel.org>
Date: Wed, 17 Jul 2013 20:00:19 +0530
Message-ID: <CAK9yfHxam3dunXcjZCHQRryWNemFCnntnQ=rf-R-reqxeR9CYg@mail.gmail.com>
Subject: Re: [PATCH 2/2] clk: exynos4: Remove unused external clock
 registration function
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 July 2013 16:29, Mark Brown <broonie@kernel.org> wrote:
> From: Mark Brown <broonie@linaro.org>
>
> As the comment says exynos4_clk_register_fixed_ext() was only used by
> non-DT platforms. Since Exynos is now DT only it is no longer referenced
> and can be removed.
>
> Signed-off-by: Mark Brown <broonie@linaro.org>

Similar patch has already been posted
http://www.spinics.net/lists/arm-kernel/msg258043.html

-- 
With warm regards,
Sachin
