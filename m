Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3FJXlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 19:41:42 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:61153 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3FJXlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 19:41:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130609152259.GC2245@breakpoint.cc>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
	<1370644273-10495-7-git-send-email-yinghai@kernel.org>
	<20130609152259.GC2245@breakpoint.cc>
Date: Mon, 10 Jun 2013 16:41:40 -0700
X-Google-Sender-Auth: JxX6zaQ4ZfRkXp7GDskmnWGzj4A
Message-ID: <CAE9FiQWBrUX40Rzn_4hg7whr7B18TLxzBiJPKOZkL+JEk8-Vhw@mail.gmail.com>
Subject: Re: [PATCH v3 06/27] ia64, irq: Add dummy create_irq_nr()
From: Yinghai Lu <yinghai@kernel.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 8:22 AM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> On Fri, Jun 07, 2013 at 03:30:52PM -0700, Yinghai Lu wrote:
>> create_irq() will return -1 when fail to allocate.
> The ia64 code here will return -ENOSPC.
>
>> create_irq_nr() will return 0 when fail to allocate.
>>
>> Will use it to fix one return value checking for dmar_msi irq.
>
> What about to unify the interface? Using -1 is kinda bad.

after some following patch, create_irq() in x86 get killed.

Still need ia64 guys to kill create_irq() in arch/ia64.

Thanks

Yinghai
