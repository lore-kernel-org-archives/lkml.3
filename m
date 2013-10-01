Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3JARmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:42:37 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60161 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3JARmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:42:31 -0400
MIME-Version: 1.0
In-Reply-To: <20131001160014.GA7438@google.com>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
	<1376189294-32022-26-git-send-email-yinghai@kernel.org>
	<20131001160014.GA7438@google.com>
Date: Tue, 1 Oct 2013 10:42:30 -0700
X-Google-Sender-Auth: aob2heWInFluF4NcXOBrmOkR8eQ
Message-ID: <CAE9FiQVSGRMbW34vQoYpLBHfu2yhh_2_MDeeRP_xEZhsTvbtqA@mail.gmail.com>
Subject: Re: [PATCH v4 25/28] PCI, x86: Make ioapic hotplug support built-in
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 1, 2013 at 9:00 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sat, Aug 10, 2013 at 07:48:11PM -0700, Yinghai Lu wrote:
>> ioapic hotplug should be built-in like pci root bus hotplug.
>>
>> Also need to make it depends on X86_IO_APIC.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Hi Yinghai,
>
> What's the status of these?  It looks like the last three or four
> could go via my PCI tree, but I don't know whether they depend on
> the earlier patches.  If they could be applied separately, I could
> merge them and we could make *some* progress.

they are rely on other patches.

would be better if you give them ack, and let them via tip/x86/irq etc.

or in two parts: after first part go to upstream via tip, and we can
push left pci related via pci tree.

>
> Also, it looks like you planned some rework related to _UID and
> resource parsing, so I've been waiting for that to show up before
> doing much more.

yes, I have that ready. will post them shortly.

Thanks

Yinghai
