Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3JRLXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:23:39 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38347 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3JRLXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <1382030498-23465-1-git-send-email-acourbot@nvidia.com>
References: <1382030498-23465-1-git-send-email-acourbot@nvidia.com>
Date: Fri, 18 Oct 2013 13:23:36 +0200
Message-ID: <CACRpkdYx07Kfs6zOQmTg2cTSmEmsGgP=7wMCSG_30NW=dfYRPQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] New descriptor-based GPIO interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 7:21 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Hi Linus,
>
> This version should merge as-is in your tree (I hope!). A patch for
> documentation will follow soon.
>
> Changes since v2:
> - rebased on top of Linus' for-next branch
> - exported new gpiod_(un)lock_as_irq() functions in driver.h
> - squashed a fix for a compilation error

Thanks, let's see if I can get this into v3.13, right now it's
unclear if I'll dare to do this. These do not apply right off
as it requires the late fixes to the gpiod code which currently
are in Torvalds' tree and on my fixes branch, so I'll merge in
v3.12-rc6 as it arrives, and then attempt to apply this on
top, but I don't know if I dare to do this so late.

The outage of linux-next also contributes to this situation.

We might have to take this as the first thing after the merge
window and targeted for v3.14.

Yours,
Linus Walleij
