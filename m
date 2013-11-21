Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab3KUPBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:01:33 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:50424 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3KUPBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:01:32 -0500
Message-ID: <1385046080.14273.8.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 0/5] gpio / ACPI: convert users to gpiod_* and drop
 acpi_gpio.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 21 Nov 2013 16:01:20 +0100
In-Reply-To: <1385045153-25160-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1385045153-25160-1-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-21 at 16:45 +0200, Mika Westerberg wrote:

> I suppose it would make sense to merge the whole series via GPIO or ACPI
> trees because there's a dependency that the first two patches need to be
> applied before last three. Otherwise the drivers in question fail to
> compile.

Totally. I wouldn't want to track it all, so ack for rfkill. Not that I
understand/know that code well anyway.

johannes

