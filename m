Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaBEMxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 07:53:10 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:46624 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaBEMxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 07:53:07 -0500
MIME-Version: 1.0
In-Reply-To: <1391529538-21685-11-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-11-git-send-email-ulf.hansson@linaro.org>
Date: Wed, 5 Feb 2014 13:53:05 +0100
Message-ID: <CACRpkdYd9zp4DhpXurNgda2GfzEHVc_ds0m2QWMhbfOtFQLqwQ@mail.gmail.com>
Subject: Re: [PATCH 10/17] spi: pl022: Remove redundant pinctrl to default
 state in probe
From: Linus Walleij <linus.walleij@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Wolfram Sang <wsa@the-dreams.de>,
        Chris Ball <chris@printf.net>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        linux-spi@vger.kernel.org,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 4:58 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:

> The driver core is now taking care of putting our pins into default
> state at probe. Thus we can remove the redundant call for it in probe.
>
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
