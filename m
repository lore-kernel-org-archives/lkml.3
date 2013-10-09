Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3JIWCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:02:17 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:63927 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3JIWCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:02:15 -0400
MIME-Version: 1.0
In-Reply-To: <5255C5B3.60004@zytor.com>
References: <20131009210219.31110.62076.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <CAErSpo4RYGakLpJuhHyGTAMXvaZc63sjLiMrMneG9NjohanVZA@mail.gmail.com> <5255C5B3.60004@zytor.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 9 Oct 2013 16:01:54 -0600
Message-ID: <CAErSpo7EJD1AvUt7ahmKR5xgQc8EpJOca2CSTcS2vG2gLa5teQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add arch/x86/pci to PCI file patterns
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 3:08 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/09/2013 02:04 PM, Bjorn Helgaas wrote:
>> On Wed, Oct 9, 2013 at 3:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> I handle many arch/x86/pci changes, so help those patches get to the
>>> PCI patchwork.
>>>
>>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>
>> I'll merge this via the PCI tree unless anybody objects.
>>
>
> Acked-by: H. Peter Anvin <hpa@zytor.com>
>
> ... as long as you don't keep us out of the loop.

Thanks.  I'm certainly not trying to keep you out of the loop; my
objective is to make get_maintainer.pl show both the x86 folks (as it
does today) *and* linux-pci (so things show up in the PCI patchwork).
I've been slow responding to an arch/x86/pci/acpi.c patch partly
because it's not in my patchwork, so it's easy to forget.

Bjorn
