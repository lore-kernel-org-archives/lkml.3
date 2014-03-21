Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966821AbaCUAjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:39:49 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:62121 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965815AbaCUAjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:39:44 -0400
Message-ID: <532B8A4B.9000808@linaro.org>
Date: Fri, 21 Mar 2014 08:39:39 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: ACPI and PM material for v3.15-rc1 (current queue)
References: <2611540.GrpzWjVQ7v@vostro.rjw.lan>
In-Reply-To: <2611540.GrpzWjVQ7v@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 2014年03月21日 08:23, Rafael J. Wysocki wrote:
> Hi All,
>
> My queue for the first pull request during the upcoming 3.15 merge window
> contains the material below.  Following the rule that everything I send
> pull requests for should spend at least one day in linux-next, I'm not
> going to add any more new commits to it at this point.
>
> Most likely, there will be more ACPI+PM pull request during the 3.15 cycle,
> so if I missed something, it still may be possible to get that into that
> kernel, but there has to be a good reason for it.
>
> Kind regards,
> Rafael
>
>
> ---------------
>
> Hanjun Guo (2):
>        ACPI / tables: Replace printk with pr_*
>        ACPI: Remove duplicate definitions of PREFIX

It seems that you missed some of my patches:
ACPI: Move BAD_MADT_ENTRY() to linux/acpi.h
ACPI / idle: Make idle_boot_override depend on x86 and ia64
ACPI / trivial: Fix the return value type of acpi_processor_eval_pdc()
ACPI / processor: Replace hard-coded "ACPI0007" with 
ACPI_PROCESSOR_DEVICE_HID

I think those 4 patches can be merged in 3.15 and you already accepted them.

and this patch still need more acks and then you will accept it:
ACPI / processor_core: Rework _PDC related stuff to make it more 
arch-independent

and this patch was reverted from your tree suggested by Catalin and Sudeep,
ACPI / processor: Introduce map_gic_id() to get apic id from MADT or 
_MAT method

Sorry for the confusion if I missed something.

Thanks
Hanjun
