Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945948Ab3BHE2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 23:28:31 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:57569 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694Ab3BHE2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 23:28:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAHp75VctZrUh5Vrxtt5XuiHf5_KFXPGkRva1713W=EMmCJUuPQ@mail.gmail.com>
References: <1360251388-16075-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAKohpo=w+LaUf0LMLBJBmEUjShCUzxKrqm5WzcrZmxAyg1vM4g@mail.gmail.com>
	<CAHp75VctZrUh5Vrxtt5XuiHf5_KFXPGkRva1713W=EMmCJUuPQ@mail.gmail.com>
Date: Fri, 8 Feb 2013 09:58:28 +0530
X-Google-Sender-Auth: uAtW8uDooiGzgqD5hdMaBfg-42E
Message-ID: <CAOh2x=kaUtstcbB+9-rMaxbKv3Nmtxqg2CE4b3Xn0+HHNwOZbw@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: add support for Lynxpoint DMA controllers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 10:35 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Thu, Feb 7, 2013 at 5:39 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 7 February 2013 21:06, Andy Shevchenko
>> <andriy.shevchenko@linux.intel.com> wrote:
>>> From: Mika Westerberg <mika.westerberg@linux.intel.com>
>>>
>>> Intel Lynxpoint PCH Low Power Subsystem has DMA controller to support general
>>> purpose serial buses like SPI, I2C, and HSUART. This controller is enumerated
>>> from ACPI namespace with ACPI ID INTL9C60.
>>>
>>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>
>> Looks like Mika is Author and you have your signed-off :)
>
> In this literally small and clear patch it doesn't matter who is who.

I believe it doesn't matter how small or big is the patch, but the author should
be there in SOBs too..

> However for sake of equity I could add Mika's signed-off-by as well.
>
> It should be:
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks.
