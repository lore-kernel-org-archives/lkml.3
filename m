Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaAGRre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:47:34 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:35299 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaAGRrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:47:25 -0500
MIME-Version: 1.0
In-Reply-To: <1385460350-17543-4-git-send-email-mika.westerberg@linux.intel.com>
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
	<1385460350-17543-4-git-send-email-mika.westerberg@linux.intel.com>
Date: Tue, 7 Jan 2014 18:47:23 +0100
Message-ID: <CACRpkdbkntK0_PzWiEXg+nAfHXpTraEq_9tEkBpcuk_ZxyoQkA@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] mmc: sdhci-acpi: convert to use GPIO descriptor API
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chris Ball <cjb@laptop.org>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 11:05 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> The new descriptor based GPIO interface is now the recommended and safer
> way of using GPIOs from device drivers. Convert the ACPI SDHCI driver to
> use that interface.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>

Chris, can I have your ACK on this patch?

Yours,
Linus Walleij
