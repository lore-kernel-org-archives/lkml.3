Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab3KFJmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:42:15 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58297 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab3KFJmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:42:13 -0500
MIME-Version: 1.0
In-Reply-To: <1383708422-20374-1-git-send-email-robherring2@gmail.com>
References: <1383708422-20374-1-git-send-email-robherring2@gmail.com>
Date: Wed, 6 Nov 2013 10:42:13 +0100
Message-ID: <CACRpkdZbVAyd9FRr39xLVVp4bmKmkGL=AUUB=sF+wSksdLcnGw@mail.gmail.com>
Subject: Re: [PATCH] gpio: pl061: don't depend on CONFIG_ARM
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 4:27 AM, Rob Herring <robherring2@gmail.com> wrote:

> From: Rob Herring <rob.herring@calxeda.com>
>
> The pl061 driver has no real dependency on ARM, so remove the kconfig
> dependency.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-gpio@vger.kernel.org

Patch applied. Let's throw it at the autobuilder and see what
happens :-)

Yours,
Linus Walleij
