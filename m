Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaEWJEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:04:20 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:36348 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaEWJEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:04:16 -0400
MIME-Version: 1.0
In-Reply-To: <1400146613-30013-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400146613-30013-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Fri, 23 May 2014 11:04:15 +0200
Message-ID: <CACRpkdadDDZ=PBNrYSbYOrwe9iZ8QXWig6EgYM45uOXE+v9fgg@mail.gmail.com>
Subject: Re: [PATCH v2 05/14] mmc: mmci: Add register read/write wrappers.
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 11:36 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> This patch adds wrappers for readl/writel functions used in the driver. The
> reason for this wrappers is to accommodate SOCs like Qualcomm which has
> requirement for delaying the write for few cycles when writing to its SD Card
> Controller registers.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
