Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3ITSGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:06:05 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:60924 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3ITSGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:06:01 -0400
MIME-Version: 1.0
In-Reply-To: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
Date: Fri, 20 Sep 2013 20:06:00 +0200
Message-ID: <CACRpkdYjkDf7c9VxfDTHtFx_upWWRAK8vpXTkrkrRsMjErq1dQ@mail.gmail.com>
Subject: Re: [RFC 0/5] New descriptor-based GPIO interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 1:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Here is a first RFC for the new GPIO interface.

I'm quite happy with this, and given that all DT-implementations will start
to use it from day 1 I'll happily merge it when you think it's tested enough.

On my wishlist is to also switch over the ACPI GPIO driver:
drivers/gpio/gpiolib-acpi.c to use the descriptors directly, so
I'd like one of the ACPI folks to have a look at this patch set
and see how it looks from their angle.

Mika, Rafael, Mathias, and either of you guys have a look
at this?

Yours,
Linus Walleij
