Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3KSJqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:46:34 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:39641 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3KSJqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:46:32 -0500
MIME-Version: 1.0
In-Reply-To: <1384825049-8214-1-git-send-email-acourbot@nvidia.com>
References: <1384825049-8214-1-git-send-email-acourbot@nvidia.com>
Date: Tue, 19 Nov 2013 10:46:31 +0100
Message-ID: <CACRpkdYU+SiMKAt1kKe12a+2RN4LXZpg4som6DGySzu8UxrGow@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: fix of_find_gpio() when OF not defined
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 2:37 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> The prototype for static GPIO lookup functions has been updated to use
> an explicit type for GPIO lookup flags. Unfortunately the definition of
> of_find_gpio() when CONFIG_OF is not defined has been omitted, which
> triggers a warning. This patch fixes this.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> --
> This fixes the kbuild test robot warning about
> "gpiolib: use dedicated flags for GPIO properties". Hopefully this can
> be squashed into this same patch. Apologies for the trouble.

Thanks!

Patch applied for fixes.

Yours,
Linus Walleij
