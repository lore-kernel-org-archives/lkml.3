Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab3JIWEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:04:12 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55061 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab3JIWEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:04:11 -0400
MIME-Version: 1.0
In-Reply-To: <1381353063.2050.24.camel@joe-AO722>
References: <20131009210219.31110.62076.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <1381353063.2050.24.camel@joe-AO722>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 9 Oct 2013 16:03:50 -0600
Message-ID: <CAErSpo7nv0tRihEJyLUQqhcTE7+VfWMoq4JQgomgkQy+nNQPPg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add arch/x86/pci to PCI file patterns
To: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 3:11 PM, Joe Perches <joe@perches.com> wrote:
> Hey Bjorn
>
> On Wed, 2013-10-09 at 15:02 -0600, Bjorn Helgaas wrote:
>> I handle many arch/x86/pci changes, so help those patches get to the
>> PCI patchwork.
>
> []
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index e61c2e8..d1ab647 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -6338,6 +6338,7 @@ S:      Supported
>>  F:   Documentation/PCI/
>>  F:   drivers/pci/
>>  F:   include/linux/pci*
>> +F:   arch/x86/pci/*
>
> This could be
>
> F:      arch/x86/pci/
>
> so that if anyone ever sticks a subdirectory
> in there, you'd still get notified.

Thanks, I made that change.

Bjorn
