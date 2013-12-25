Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3LYIIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 03:08:19 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:49131 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3LYIIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 03:08:17 -0500
Message-ID: <52BA923F.6000804@huawei.com>
Date: Wed, 25 Dec 2013 16:07:27 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Vasiliy Tolstov <v.tolstov@selfip.ru>,
        Robert Hancock <hancockrwd@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: tg3 and sd card reader at acer aspire
References: <CACaajQv1OWxxcGORBq=LN-4JQzATf4YmWBQymoeyovfY-rUpmw@mail.gmail.com> <CAErSpo4uZ1N7uKyKMGHERtq-gvcpQ7oHTE7U9fGiAzfziMJ+Ew@mail.gmail.com> <52BA3A72.6080700@gmail.com> <CACaajQv=UtqEfLU3vLPmixpvUf7u7D9NPZ-s6s_BMvPpSDVAig@mail.gmail.com>
In-Reply-To: <CACaajQv=UtqEfLU3vLPmixpvUf7u7D9NPZ-s6s_BMvPpSDVAig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/25 15:51, Vasiliy Tolstov wrote:
> 2013/12/25 Robert Hancock <hancockrwd@gmail.com>:
>> So apparently this machine got broken when we changed the behavior for the
>> ACPI ASPM-not-supported bit from forcing ASPM off for everything to leaving
>> ASPM in whatever state the BIOS left it in. And apparently for some reason
>> the device (devices?) doesn't work with ASPM enabled in Linux but does in
>> Windows. It's possible that some other workaround is being applied by the
>> Windows driver that allows it to work there.
>>
>> I'm not too sure what the next step to debug that would be, unless maybe
>> someone has a contact at Broadcom. We could conceivably add a quirk to force
>> ASPM off for this device regardless of what the BIOS says, though.
> 
> 
> Thanks! I can contact with broadcom, but i don't known email address.
> Last my attempt then i have problems with their wifi card not
> successful =(.

Maybe BROADCOM TG3 driver maintainer list can help you.

More info can be found in MAINTAINERS file under linux kernel source directory.

BROADCOM TG3 GIGABIT ETHERNET DRIVER
M:      Nithin Nayak Sujir <nsujir@broadcom.com>
M:      Michael Chan <mchan@broadcom.com>
L:      netdev@vger.kernel.org
S:      Supported
F:      drivers/net/ethernet/broadcom/tg3.*

> 
> 


-- 
Thanks!
Yijing

