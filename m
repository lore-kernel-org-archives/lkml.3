Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaEWJJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:09:05 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:46840 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaEWJJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:09:02 -0400
MIME-Version: 1.0
In-Reply-To: <1400146660-30261-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400146660-30261-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Fri, 23 May 2014 11:09:02 +0200
Message-ID: <CACRpkdYZOpqyGJT4_Kf-TetiQoQrJwWbSrqUxDuRszutEM0HWw@mail.gmail.com>
Subject: Re: [PATCH v2 11/14] mmc: mmci: Add support to data commands via
 variant structure.
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

On Thu, May 15, 2014 at 11:37 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> On some SOCs like Qcom there are explicit bits in the command register
> to specify if its a data transfer command or not. So this patch adds
> support to such bits in variant data, giving more flexibility to the
> driver.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
