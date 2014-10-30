Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161056AbaJ3Pmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:42:49 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:45779 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934156AbaJ3Pmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:42:46 -0400
MIME-Version: 1.0
In-Reply-To: <1414570394-11706-1-git-send-email-acourbot@nvidia.com>
References: <1414570394-11706-1-git-send-email-acourbot@nvidia.com>
Date: Thu, 30 Oct 2014 16:42:45 +0100
Message-ID: <CACRpkda6GzoyKmx95u-exzrVrGfGfB8n-Z6iHWJ=mMQtgi4Wyg@mail.gmail.com>
Subject: Re: [PATCH v2] Documentation: gpio: guidelines for bindings
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 9:13 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Now that ACPI supports named GPIO properties, either through ACPI 5.1 or
> the per-driver ACPI GPIO mappings, we can be more narrow about the way
> GPIOs should be specified in Device Tree bindings.
>
> This patch updates the GPIO DT bindings documentation to highlight the
> following rules for new GPIO bindings:
>
> - All new bindings must have a meaningful name (e.g. the "gpios"
>   property must not be used)
> - The only suffix allowed is "-gpios", no matter the number of
>   descriptors in the property
> - GPIOs can only be grouped under the same property when they serve the
>   same purpose, a case that should remain exceptional (e.g. bit-banged
>   data lines).
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Rafael J. Wysocki <rjw@rjwysocki.net>
> CC: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> Changes since v1:
> - Rewritten in OS-neutral manner.

Patch applied with the ACKs, thanks!

Yours,
Linus Walleij
