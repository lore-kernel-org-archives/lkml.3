Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbbAOQe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:34:59 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33587 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbbAOQe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:34:56 -0500
MIME-Version: 1.0
In-Reply-To: <1420481779-22841-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1420481779-22841-1-git-send-email-soren.brinkmann@xilinx.com>
Date: Thu, 15 Jan 2015 17:34:55 +0100
Message-ID: <CACRpkdYJ_kZw3UfYc5vGd0cxwDJD5WR69c6Q5xTvmFnb7NOfkA@mail.gmail.com>
Subject: Re: [PATCH RESEND v3] gpio: lib-sysfs: Add 'wakeup' attribute
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Johan Hovold <johan@kernel.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-api@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 7:16 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> marking/unmarking a GPIO as wake IRQ.
> The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
> is associated with that GPIO and the irqchip implements set_wake().
> Writing 'enabled' to that file will enable wake for that GPIO, while
> writing 'disabled' will disable wake.
> Reading that file will return either 'disabled' or 'enabled' depening on
> the currently set flag for the GPIO's IRQ.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> v3:
>  - add documentation

As per discussion with Johan Hovold I have had to remove this patch
from the development tree.

Please rebase as indicated on the "fixes" branch, fix any resource
leaks, include Johan Hovold on CC for review and resend.

Yours,
Linus Walleij
