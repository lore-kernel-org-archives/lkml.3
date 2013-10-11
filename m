Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab3JKKwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:52:34 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40209 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758299Ab3JKKwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:52:31 -0400
MIME-Version: 1.0
In-Reply-To: <1380639537-23406-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
	<1380639537-23406-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Fri, 11 Oct 2013 12:52:30 +0200
Message-ID: <CACRpkdb8iDpXsTLJr0mXpSHeqs2DkdBw6u+=TaerxwsA37kj2g@mail.gmail.com>
Subject: Re: [PATCH 1/5] gpiolib / ACPI: move acpi_gpiochip_free_interrupts
 next to the request function
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

On Tue, Oct 1, 2013 at 4:58 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> It makes more sense to have these functions close to each other. No
> functional changes.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied.

Yours,
Linus Walleij
