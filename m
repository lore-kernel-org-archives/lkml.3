Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab3BGPj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:39:59 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:61557 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3BGPj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:39:58 -0500
MIME-Version: 1.0
In-Reply-To: <1360251388-16075-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1360251388-16075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 7 Feb 2013 21:09:57 +0530
Message-ID: <CAKohpo=w+LaUf0LMLBJBmEUjShCUzxKrqm5WzcrZmxAyg1vM4g@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: add support for Lynxpoint DMA controllers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 February 2013 21:06, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> Intel Lynxpoint PCH Low Power Subsystem has DMA controller to support general
> purpose serial buses like SPI, I2C, and HSUART. This controller is enumerated
> from ACPI namespace with ACPI ID INTL9C60.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Looks like Mika is Author and you have your signed-off :)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
