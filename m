Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaBVRav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:30:51 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:45948 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaBVRat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:30:49 -0500
MIME-Version: 1.0
In-Reply-To: <5308C343.5040102@linux.intel.com>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
	<1388707565-16535-11-git-send-email-yinghai@kernel.org>
	<53070393.5020005@linux.intel.com>
	<CAE9FiQV8B271XCJQV=80S6pZDOVxG9LG0gaj9G98dCRetjkMUg@mail.gmail.com>
	<53081614.4020503@linux.intel.com>
	<CAE9FiQXnMgG=mOmcSK9ZwKR6tFAkJX2dVnGTj9Mmg3daDhPmEA@mail.gmail.com>
	<5308C343.5040102@linux.intel.com>
Date: Sat, 22 Feb 2014 09:30:48 -0800
X-Google-Sender-Auth: O_8Us_EAYz3xZVWEvuc91s_ukps
Message-ID: <CAE9FiQWp1AU2BeX_yyTmPm662T08kJfzSGbq_Nzy3jM6VAm9yQ@mail.gmail.com>
Subject: Re: [PATCH v5 10/33] iommu, irq: Allocate irq_desc for dmar_msi with
 local node
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Donald Dutile <ddutile@redhat.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 7:33 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> Hi Yinghai,
>         I have a plan to test this patch set once I have reviewed
> all patches in coming weeks. Do you have a plan to update to latest
> kernel or is it ok to test this version?

That will be great. I will refresh the branch on top of
linus/tip/pci/acpi next week.

Thanks

Yinghai
