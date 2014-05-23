Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaEWJIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:08:15 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:44052 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaEWJIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <1400146651-30220-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400146651-30220-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Fri, 23 May 2014 11:08:10 +0200
Message-ID: <CACRpkdazzobtRWeVREvFVkAkZDdEpx1UoSNx=q8wm8QeTuZHTA@mail.gmail.com>
Subject: Re: [PATCH v2 10/14] mmc: mmci: add Qcom specifics of clk and
 datactrl registers.
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
> This patch adds specifics of clk and datactrl register on Qualcomm SD
> Card controller. This patch also populates the Qcom variant data with
> these new values specific to Qualcomm SD Card Controller.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Now it looks real elegant.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
