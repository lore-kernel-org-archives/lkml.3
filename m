Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbaEMHTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:19:24 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:43055 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174AbaEMHTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:19:20 -0400
MIME-Version: 1.0
In-Reply-To: <1398759571-13095-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1398759571-13095-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Tue, 13 May 2014 09:19:19 +0200
Message-ID: <CACRpkdY6QLpJQuNqC4qqsPWgVTxF8NiGd=eWUEWRkzdh68j9_A@mail.gmail.com>
Subject: Re: [PATCH v1 03/11] mmc: mmci: Add Qcom datactrl register variant
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 10:19 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> Instance of this IP on Qualcomm's SOCs has bit different layout for datactrl
> register. Bit postion datactrl[16:4] hold the true block size instead of power
> of 2.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This is probably something I got wrong when I attempted to use
this driver on the Dragon board. Now I see what I missed...

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
