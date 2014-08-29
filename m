Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaH2G5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 02:57:33 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37265 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaH2G5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 02:57:32 -0400
MIME-Version: 1.0
In-Reply-To: <1408467969-21226-2-git-send-email-acourbot@nvidia.com>
References: <1408467969-21226-1-git-send-email-acourbot@nvidia.com>
	<1408467969-21226-2-git-send-email-acourbot@nvidia.com>
Date: Fri, 29 Aug 2014 08:57:31 +0200
Message-ID: <CACRpkdb-u_HUmmSnqZxCqcR-E+OG0zFKiE8shEG-7xD0HUcfgg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] gpio: acpi: normalize use of gpiochip_get_desc()
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 7:06 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> GPIO descriptors are changing from unique and permanent tokens to
> allocated resources. Therefore gpiochip_get_desc() cannot be used as a
> way to obtain a global GPIO descriptor anymore.
>
> This patch updates the gpiolib ACPI support code to keep and use the
> descriptor returned by a centralized call to gpiochip_get_desc().
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied.

Yours,
Linus Walleij
