Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab3KWJX5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 04:23:57 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:40365 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3KWJXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 04:23:54 -0500
MIME-Version: 1.0
In-Reply-To: <1385122474-14926-5-git-send-email-mika.westerberg@linux.intel.com>
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
 <1385122474-14926-5-git-send-email-mika.westerberg@linux.intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 23 Nov 2013 18:23:34 +0900
Message-ID: <CAAVeFuJHFHfdt1n4j7+iAn7hJGcOaZNvKWmTv4r8E3n4gVTPUg@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] mmc: sdhci-acpi: covert to use GPIO descriptor API
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 9:14 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> The new descriptor based GPIO interface is now the recommended and safer
> way of using GPIOs from device drivers. Convert the ACPI SDHCI driver to
> use that interface.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
