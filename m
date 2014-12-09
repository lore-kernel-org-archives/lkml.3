Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaLIVu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:50:29 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:52646 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaLIVu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:50:26 -0500
MIME-Version: 1.0
In-Reply-To: <54854FB2.8080206@linaro.org>
References: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org>
 <3957412.IooRKpIXjW@wuerfel> <20141121180825.GD6578@google.com>
 <2178540.dTppAIY2rE@wuerfel> <54854FB2.8080206@linaro.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 9 Dec 2014 14:50:05 -0700
Message-ID: <CAErSpo6cUuEK41wD33Uyzb5Y5yFp+jKVVvWLrZ0dO1iuYv8GjQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] pci, acpi: Share ACPI PCI config space accessors.
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 12:13 AM, Tomasz Nowicki
<tomasz.nowicki@linaro.org> wrote:

> What would be next steps regarding this patch set? I am not sure we have
> reached a consensus on weak vs #ifdef choice.

I work through the list at
https://patchwork.ozlabs.org/project/linux-pci/list/ in FIFO order, so
you don't need to do anything else except poke me to move faster :)

The weak/ifdef question is relatively minor and easily changed, so I
wouldn't worry about it yet.

Bjorn
