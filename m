Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3GQO0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:26:55 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62358 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab3GQO0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:26:53 -0400
MIME-Version: 1.0
In-Reply-To: <1374058786-16603-1-git-send-email-broonie@kernel.org>
References: <1374058786-16603-1-git-send-email-broonie@kernel.org>
Date: Wed, 17 Jul 2013 19:56:52 +0530
Message-ID: <CAK9yfHxdL0KpS0R_zBqiRGO=E-PMkv6JfwZpyTrHL0nPv3iCgQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] clk: samsung: Staticise non-exported symbols
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
> This avoids polluting the global namespace and silences lots of sparse
> warnings. The change pushes us over 80 columns a lot but I couldn't see
> a tasteful place to break the lines as-is.
>
> Signed-off-by: Mark Brown <broonie@linaro.org>

I have already posted a series which does similar things:
comments.gmane.org/gmane.linux.kernel.samsung-soc/20696


-- 
With warm regards,
Sachin
