Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3JSVfm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 17:35:42 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:56452 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3JSVfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 17:35:40 -0400
MIME-Version: 1.0
In-Reply-To: <1381392071-21407-6-git-send-email-mika.westerberg@linux.intel.com>
References: <1381392071-21407-1-git-send-email-mika.westerberg@linux.intel.com>
	<1381392071-21407-6-git-send-email-mika.westerberg@linux.intel.com>
Date: Sat, 19 Oct 2013 23:35:39 +0200
Message-ID: <CACRpkdaAgsoO=w6=LDqE4-JZaOY7Ooofa_L2tRL2Hnt6SNh70g@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] gpiolib / ACPI: document the GPIO descriptor based interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:01 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> In addition to the existing ACPI specific GPIO interface, document the new
> descriptor based GPIO interface in Documentation/acpi/enumeration.txt, so
> it is clear that this new interface is preferred over the ACPI specific
> version.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

I've applied the last 4 of these patches now as well, on top of
Alexandre's gpiod interface. If you can, please test the result
on my "devel" branch and let's see if the autobuilder likes it too...

Yours,
Linus Walleij
