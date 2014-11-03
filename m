Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaKCXY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:24:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55463 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaKCXY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:24:57 -0500
MIME-Version: 1.0
In-Reply-To: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Mon, 3 Nov 2014 17:24:55 -0600
Message-ID: <CAOZdJXXAQtmR_Wq194nbiEpg2TYS7_5tXhLtDWckD4xMHGkdZg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
From: Timur Tabi <timur@codeaurora.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 5:01 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> Hi,
>
> This is second version of the patch series adding pinctrl/GPIO support
> for Intel Braswell and Cherrryview. The previous version can be found here:
>
> https://lkml.org/lkml/2014/10/27/118
>
> I've dropped patches [2/4] and [3/4] as they are already applied to the
> pinctrl tree.

Mika,

I am also trying to add ACPI enablement to my pinctrl driver (not yet
submitted), but I'm new to ACPI and pin control drivers, so I have a
lot of catching up to do.

In reviewing this patchset, it appears to me that pinctrl-cherryview.c
is a normal pinctrl driver that has an acpi_match_table entry, and
nothing more.

Assuming that this driver is booting on an ACPI system, what is the
mechanism that calls into the driver to configure the pins?  Is there
a definition for pin control in ASL that provides similar
functionality as the pinctrl nodes in a device tree?
