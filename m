Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066Ab3BGRFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:05:44 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:53720 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867Ab3BGRFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:05:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=w+LaUf0LMLBJBmEUjShCUzxKrqm5WzcrZmxAyg1vM4g@mail.gmail.com>
References: <1360251388-16075-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAKohpo=w+LaUf0LMLBJBmEUjShCUzxKrqm5WzcrZmxAyg1vM4g@mail.gmail.com>
Date: Thu, 7 Feb 2013 19:05:40 +0200
Message-ID: <CAHp75VctZrUh5Vrxtt5XuiHf5_KFXPGkRva1713W=EMmCJUuPQ@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: add support for Lynxpoint DMA controllers
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 5:39 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 7 February 2013 21:06, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> From: Mika Westerberg <mika.westerberg@linux.intel.com>
>>
>> Intel Lynxpoint PCH Low Power Subsystem has DMA controller to support general
>> purpose serial buses like SPI, I2C, and HSUART. This controller is enumerated
>> from ACPI namespace with ACPI ID INTL9C60.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
> Looks like Mika is Author and you have your signed-off :)

In this literally small and clear patch it doesn't matter who is who.
However for sake of equity I could add Mika's signed-off-by as well.

It should be:
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>


> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>



-- 
With Best Regards,
Andy Shevchenko
