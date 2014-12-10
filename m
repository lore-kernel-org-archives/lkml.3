Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbaLJGQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:16:36 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49548 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbaLJGQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:16:34 -0500
Message-ID: <5487E539.3000500@linaro.org>
Date: Wed, 10 Dec 2014 07:16:25 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Myron Stowe <myron.stowe@gmail.com>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linaro-acpi@lists.linaro.org, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, x86 <x86@kernel.org>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Hanjun Guo <hanjun.guo@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yijing Wang <wangyijing@huawei.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] pci, acpi: Share ACPI PCI config space accessors.
References: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org> <3957412.IooRKpIXjW@wuerfel> <20141121180825.GD6578@google.com> <2178540.dTppAIY2rE@wuerfel> <54854FB2.8080206@linaro.org> <CAErSpo6cUuEK41wD33Uyzb5Y5yFp+jKVVvWLrZ0dO1iuYv8GjQ@mail.gmail.com>
In-Reply-To: <CAErSpo6cUuEK41wD33Uyzb5Y5yFp+jKVVvWLrZ0dO1iuYv8GjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 09.12.2014 o 22:50, Bjorn Helgaas pisze:
> On Mon, Dec 8, 2014 at 12:13 AM, Tomasz Nowicki
> <tomasz.nowicki@linaro.org> wrote:
>
>> What would be next steps regarding this patch set? I am not sure we have
>> reached a consensus on weak vs #ifdef choice.
>
> I work through the list at
> https://patchwork.ozlabs.org/project/linux-pci/list/ in FIFO order, so
> you don't need to do anything else except poke me to move faster :)

Awesome! I guess I am good at poke people so you can count on me :)

Regards,
Tomasz



