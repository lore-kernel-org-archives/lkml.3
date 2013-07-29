Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3G2MQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:16:37 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:51743 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab3G2MQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:16:35 -0400
Message-ID: <51F65D1F.9050402@cogentembedded.com>
Date: Mon, 29 Jul 2013 16:16:31 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Joe Perches <joe@perches.com>, Lan Tianyu <lantianyu1986@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/3] ACPI / PM: Make messages in acpi_device_set_power()
 print device names
References: <10433383.dueoNg39qi@vostro.rjw.lan> <CAOLK0pyBsD8vR0a2mcSucnD8zFTz8ZB72OPE0R9Z67SxH9VHRw@mail.gmail.com> <1375067513.2075.27.camel@joe-AO722> <1782275.A7JEhQIj8Q@vostro.rjw.lan>
In-Reply-To: <1782275.A7JEhQIj8Q@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 29-07-2013 16:17, Rafael J. Wysocki wrote:

[...]

>>>> @@ -166,20 +166,20 @@ int acpi_device_set_power(struct acpi_de
>> []
>>>>          if (device->parent && (state < device->parent->power.state)) {
>>>> -               printk(KERN_WARNING PREFIX
>>>> -                             "Cannot set device to a higher-powered"
>>>> -                             " state than parent\n");
>>>> +               dev_warn(&device->dev, "Cannot transition to a higher-powered "
>>>> +                        "state than parent\n");

>> coalesce format please.

> I can, but then it'll cross the 80 columns boundary.

   It's not a problem with checkpatch.pl anymore. Contrariwise, it whines 
about the broken up string literals, AFAIR.

> Thanks,
> Rafael

WBR, Sergei

