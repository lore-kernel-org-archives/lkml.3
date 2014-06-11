Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbaFKMuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:50:15 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:59756 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbaFKMuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:50:13 -0400
MIME-Version: 1.0
In-Reply-To: <1401700195-11834-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1401700195-11834-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Wed, 11 Jun 2014 14:50:12 +0200
Message-ID: <CACRpkda=ZU2NoTjw1b_h8kv4TYPrmxqv5o-3hN+s1oidNV646Q@mail.gmail.com>
Subject: Re: [PATCH v6 10/12] mmc: mmci: add explicit clk control
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

On Mon, Jun 2, 2014 at 11:09 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> On Controllers like Qcom SD card controller where cclk is mclk and mclk should
> be directly controlled by the driver.
>
> This patch adds support to control mclk directly in the driver, and also
> adds explicit_mclk_control flag in variant structure giving more flexibility
> to the driver.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
