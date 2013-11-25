Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3KYWTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:19:09 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43490 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab3KYWTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:19:04 -0500
MIME-Version: 1.0
In-Reply-To: <5281E97D.6090806@suse.cz>
References: <1384177236-8371-1-git-send-email-mmarek@suse.cz> <5281E97D.6090806@suse.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 25 Nov 2013 15:18:42 -0700
Message-ID: <CAErSpo6sCvDuSA3Bw0LY7D6QYC=xhPP05f966kjDP0mvqu5wEg@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: Do not use PCI ID macros in quirk names
To: Michal Marek <mmarek@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Joe Mario <jmario@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 1:40 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 11.11.2013 14:40, Michal Marek wrote:
>> Pasting the verbatim PCI_(VENDOR|DEVICE)_* macros in the __pci_fixup_*
>> symbol names results in insanely long names such as
>>
>> __pci_fixup_resumePCI_VENDOR_ID_SERVERWORKSPCI_DEVICE_ID_SERVERWORKS_HT1000SBquirk_disable_broadcom_boot_interrupt
>>
>> When LTO adds its numeric suffix to such symbol, it overflows the
>> namebuf[KSYM_NAME_LEN] array. Use the line number instead to create
>
> "... the namebuf[KSYM_NAME_LEN] array in kernel/kallsyms.c."

What's LTO?  I guess it's Link Time Optimization?  Is there any
documentation about how it works or how to use it?

Bjorn
