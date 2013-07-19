Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3GSVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:25:27 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57136 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3GSVZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130717075813.GA14629@gmail.com>
References: <1373874048-20258-1-git-send-email-valentina.manea.m@gmail.com> <20130717075813.GA14629@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 19 Jul 2013 15:25:04 -0600
Message-ID: <CAErSpo4s2DU0AMJBE5twDcDvbUXcT=OqAKCRJUt4H5cqEqyokg@mail.gmail.com>
Subject: Re: [PATCH v2] x86/pci: checkpatch.pl cleanup
To: Ingo Molnar <mingo@kernel.org>
Cc: Valentina Manea <valentina.manea.m@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bin Gao <bin.gao@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 1:58 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Valentina Manea <valentina.manea.m@gmail.com> wrote:
>
>> This patch fixes warning and errors found by checkpatch.pl:
>>
>> * replace asm/acpi.h, asm/io.h and asm/smp.h with linux/acpi.h,
>> linux/io.h and linux/smp.h respectively
>> * remove explicit initialization to 0 of a static global variable
>> * replace printk(KERN_INFO ...) with pr_info
>> * use tabs instead of spaces for indentation
>> * arrange comments so that they adhere to Documentation/CodingStyle
>>
>> Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
>
> Looks good, thanks.
>
> Bjorn, I can pick this up into tip:x86/cleanups, or would you like to put
> this into the PCI tree?

I added your ack, capitalized "PCI", "Langwell", etc. consistently,
and put it in my pci/misc branch.

Bjorn
