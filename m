Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbaDOFHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:07:30 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:58213 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaDOFH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:07:26 -0400
MIME-Version: 1.0
In-Reply-To: <534BEEED.1060309@samsung.com>
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
	<1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
	<534529B2.2020107@samsung.com>
	<534BCC91.8090108@ti.com>
	<CAFp+6iGxhfgZRPysMuj5nALEQBbFXnAXhtDPpbf3P42LDHqFxg@mail.gmail.com>
	<534BDD17.60003@ti.com>
	<534BE658.8050606@gmail.com>
	<CAFp+6iHhUvLhAKGPARS8RUfmO8RGcTrumvYb7QjJXbFD1nUuig@mail.gmail.com>
	<534BEEED.1060309@samsung.com>
Date: Tue, 15 Apr 2014 10:37:25 +0530
Message-ID: <CAFp+6iFQes3xSj7V7a0sCPaD1oXNccgp3j5ZNNPUqJPXHu9OSg@mail.gmail.com>
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,


On Mon, Apr 14, 2014 at 7:51 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 14/04/14 15:49, Vivek Gautam wrote:
>> True, we don't have a scope of instantiating this driver using old
>> platform device and
>> old legacy board files.
>> So we don't need this check then, right ?
>
> I think it can be dropped.
> At least IMHO there is no point to increase size of the module with
> an error log that has no chance to be ever called in practice.

Ok, i will remove this error message and in fact this check.



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
