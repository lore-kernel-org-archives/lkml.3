Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab3K1Ogo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:36:44 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:48340 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3K1Ogl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:36:41 -0500
MIME-Version: 1.0
In-Reply-To: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 28 Nov 2013 15:36:40 +0100
Message-ID: <CACRpkdbJsQOjJ5QLVL9WutN9c04-AfRKe-hCYZ0fxDKsfCZS6Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] gpio / ACPI: convert users to gpiod_* and drop acpi_gpio.h
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

> Since the patches in the series depend on each other I would propose this
> to be merged via GPIO tree.

Sure! Can you hunt the net/mmc/Tegra subsystem maintainers
for ACKs please?

(Haven't looked close at v3 yet, bear with me if you already have
some ACKs...)

Yours,
Linus Walleij
