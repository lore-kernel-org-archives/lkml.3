Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbaISIWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:22:38 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35637 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaISIWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:22:36 -0400
MIME-Version: 1.0
In-Reply-To: <1410868367-11056-13-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1410868367-11056-13-git-send-email-mika.westerberg@linux.intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 19 Sep 2014 17:22:15 +0900
Message-ID: <CAAVeFuLiZD15t=4WQNWUgJvKH9pgHTWSPC8YXrf4TFY9Hn7sXg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 12/16] input: gpio_keys_polled - Add support for
 GPIO descriptors
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 8:52 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> From: Aaron Lu <aaron.lu@intel.com>
>
> GPIO descriptors are the preferred way over legacy GPIO numbers
> nowadays. Convert the driver to use GPIO descriptors internally but
> still allow passing legacy GPIO numbers from platform data to support
> existing platforms.
>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
