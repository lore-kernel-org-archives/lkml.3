Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698Ab3DKWfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:35:09 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:55501 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3DKWfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:35:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130411072912.GE1283@intel.com>
References: <1364986614-15711-1-git-send-email-mika.westerberg@linux.intel.com>
	<15166969.9Sfs2U7qQb@vostro.rjw.lan>
	<20130411072912.GE1283@intel.com>
Date: Fri, 12 Apr 2013 00:35:05 +0200
Message-ID: <CACRpkdYiNOLVAgZVhZG3OaJw5ZZ4OM8RPafCxPPfMWo2gVM=dg@mail.gmail.com>
Subject: Re: [PATCH] gpiolib-acpi: introduce acpi_get_gpio_by_index() helper
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 9:29 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> Grant and Linus W,
>
> Do you have any comments on this patch? Could it still be merged for 3.10?

No and yes.

Applied and pushed for linux-next now.

Sorry for taking so long, I was confused by the discussion.

I had to use some fuzzing to apply the patch, please check the
result in linux-next.

Linus
