Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3H1GRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:17:18 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:65205 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab3H1GRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:17:15 -0400
MIME-Version: 1.0
In-Reply-To: <CANVTcTbGrh-LccBiC5CHRc9dh9jUOwup-MVa-iHK65n+TTXE2A@mail.gmail.com>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
	<1376189294-32022-27-git-send-email-yinghai@kernel.org>
	<CANVTcTYhdiptB_sOUyveBfieg0VkTGdor16kCHKkJDemHzcWXw@mail.gmail.com>
	<CAE9FiQVSRMdinMKQdJUB_q8pAK-ei-Q-if+8K5yyz=HRTHbCTA@mail.gmail.com>
	<CANVTcTZT-0bg=GBdo06=1--NgyMEM6-pFX8DjMxh=7JYtaTLpw@mail.gmail.com>
	<CAE9FiQVM+q=PjZ+Q_wR2-BGrbs+gBcGyKFhOqGZdZWyxjMjB0g@mail.gmail.com>
	<CANVTcTbGrh-LccBiC5CHRc9dh9jUOwup-MVa-iHK65n+TTXE2A@mail.gmail.com>
Date: Tue, 27 Aug 2013 23:17:15 -0700
X-Google-Sender-Auth: RoWt4yEYX98sUn73LkuBnlebhJc
Message-ID: <CAE9FiQUYY5rXie8gEGpBcdjpzs8AD++HKAFw9Xg-gLH6vhR_8w@mail.gmail.com>
Subject: Re: [PATCH v4 26/28] PCI, x86, ACPI: Link acpi ioapic register to ioapic
From: Yinghai Lu <yinghai@kernel.org>
To: rui wang <ruiv.wang@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 3:08 AM, rui wang <ruiv.wang@gmail.com> wrote:
> On 8/27/13, Yinghai Lu <yinghai@kernel.org> wrote:
>>> It's a bit challenge how you'll conjure unique identifiers from both
>>> integers and strings. If you have a new patch I can help try it out.
>>
>> Then do you have _MAT with that ioapic device or else?
>>
>> need to find the _MAT entry with GSM matching to find out ioapic id.
>>
>
> There's no _MAT for the IOAPICs. I only find _MAT for the LAPICs. But
> there's a static MADT in APIC.dsl which contains IOAPIC entries with
> ioapic ids.

ok, will change to check _MAT at first and fall back to MADT.

Yinghai
