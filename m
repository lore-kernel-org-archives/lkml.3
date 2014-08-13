Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaHMIz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:55:58 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:38404 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaHMIz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:55:56 -0400
MIME-Version: 1.0
In-Reply-To: <1407845102-8402-1-git-send-email-srinivas.kandadgatla@linaro.org>
References: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
	<1407845102-8402-1-git-send-email-srinivas.kandadgatla@linaro.org>
Date: Wed, 13 Aug 2014 10:55:55 +0200
Message-ID: <CACRpkda2qQ+3eG032Ln2hWYGJ3rkeCwqjvYc9hYBzQFGgGjiOg@mail.gmail.com>
Subject: Re: [PATCH RFC 4/5] mmc: mmci: Add sdio enable mask in variant data
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 2:05 PM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> This patch adds sdio enable mask in variant data, SOCs like ST have
> special bits in datactrl register to enable sdio. Unconditionally setting
> this bit in this driver breaks other SOCs like Qualcomm which maps this
> bits to something else, so making this enable bit to come from variant
> data solves the issue.
>
> Originally the issue is detected while testing WLAN ath6kl on Qualcomm
> APQ8064.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
