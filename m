Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628AbaAFWrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:47:52 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:46330 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327AbaAFWru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:47:50 -0500
X-Greylist: delayed 10042 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2014 17:47:50 EST
MIME-Version: 1.0
In-Reply-To: <20140103224713.GC18987@google.com>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
	<1388707565-16535-26-git-send-email-yinghai@kernel.org>
	<20140103224713.GC18987@google.com>
Date: Mon, 6 Jan 2014 14:47:47 -0800
X-Google-Sender-Auth: bZkpAxcM5AMnr860fjIAgwVqIZQ
Message-ID: <CAE9FiQXa0RK8ht=91dGFj0mC-KQqJjxHXfnh4Td5EUhxEf8M6g@mail.gmail.com>
Subject: Re: [PATCH v5 25/33] PCI, x86: Make ioapic hotplug support built-in
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 2:47 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [fixed Rafael's email address; I imagine you got a few bounces :)]
>
> On Thu, Jan 02, 2014 at 04:05:57PM -0800, Yinghai Lu wrote:
>> ioapic hotplug should be built-in like pci root bus hotplug.
>>
>> Also need to make it depends on X86_IO_APIC.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Most of this series is x86-specific and outside the scope of PCI, so I
> assume somebody else will deal with it.

Yes.

>
> This particular patch doesn't seem to depend on anything else, so I'll
> merge it.

yes.
