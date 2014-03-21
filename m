Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaCUQY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:24:58 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51289 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751574AbaCUQYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:24:55 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: ACPI and PM material for v3.15-rc1 (current queue)
Date: Fri, 21 Mar 2014 17:40:26 +0100
Message-ID: <4752174.DIeOl6EhdE@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <532B8A4B.9000808@linaro.org>
References: <2611540.GrpzWjVQ7v@vostro.rjw.lan> <532B8A4B.9000808@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 21, 2014 08:39:39 AM Hanjun Guo wrote:
> Hi Rafael,

Hi,

> On 2014年03月21日 08:23, Rafael J. Wysocki wrote:
> > Hi All,
> >
> > My queue for the first pull request during the upcoming 3.15 merge window
> > contains the material below.  Following the rule that everything I send
> > pull requests for should spend at least one day in linux-next, I'm not
> > going to add any more new commits to it at this point.
> >
> > Most likely, there will be more ACPI+PM pull request during the 3.15 cycle,
> > so if I missed something, it still may be possible to get that into that
> > kernel, but there has to be a good reason for it.
> >
> > Kind regards,
> > Rafael
> >
> >
> > ---------------
> >
> > Hanjun Guo (2):
> >        ACPI / tables: Replace printk with pr_*
> >        ACPI: Remove duplicate definitions of PREFIX
> 
> It seems that you missed some of my patches:
> ACPI: Move BAD_MADT_ENTRY() to linux/acpi.h
> ACPI / idle: Make idle_boot_override depend on x86 and ia64
> ACPI / trivial: Fix the return value type of acpi_processor_eval_pdc()
> ACPI / processor: Replace hard-coded "ACPI0007" with 
> ACPI_PROCESSOR_DEVICE_HID
> 
> I think those 4 patches can be merged in 3.15 and you already accepted them.

Yes, I did not include the acpi-processor branch, sorry about that and thanks
for spotting it!

That branch was in linux-next before, though, so I'll push it for 3.15-rc1.

> and this patch still need more acks and then you will accept it:
> ACPI / processor_core: Rework _PDC related stuff to make it more 
> arch-independent
> 
> and this patch was reverted from your tree suggested by Catalin and Sudeep,
> ACPI / processor: Introduce map_gic_id() to get apic id from MADT or 
> _MAT method
> 
> Sorry for the confusion if I missed something.

I don't think you missed anything, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
