Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaEVVuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:50:04 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:58575 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaEVVuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:50:02 -0400
MIME-Version: 1.0
In-Reply-To: <1400167727-20233-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1400167727-20233-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 22 May 2014 23:50:00 +0200
Message-ID: <CACRpkdY28sT8jG750F9n6T=NBcsuvN3ZKpOtt4e4=VWDBJr_uA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: baytrail: Add back Baytrail-T ACPI ID
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jin Yao <yao.jin@intel.com>,
        Aubrey Li <aubrey.li@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 5:28 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> From: Jin Yao <yao.jin@intel.com>
>
> Now that the x86 dynamic IRQ allocation problem has been resolved with
> commmit 62a08ae2a576 (genirq: x86: Ensure that dynamic irq allocation does
> not conflict), we can add back Baytrail-T ACPI ID to the pinctrl driver.
>
> This makes the driver to work on Asus T100 where it is needed for several
> things like ACPI GPIO events and SD card detection.
>
> References: https://bugzilla.kernel.org/show_bug.cgi?id=68291
> Signed-off-by: Jin Yao <yao.jin@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied with Rafael's ACK.

Applying this and 2/2 to v3.16 though, protest if there is a problem with this.

Yours,
Linus Walleij
