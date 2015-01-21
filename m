Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbbAUO0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:26:30 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51353 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753166AbbAUO0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:26:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC Patch 08/19] ACPI: Add prefetch decoding to the address space parser
Date: Wed, 21 Jan 2015 15:48:57 +0100
Message-ID: <2824802.T2m64639rV@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54BF3881.9000708@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1593565.fJ4zH7YgDd@vostro.rjw.lan> <54BF3881.9000708@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 21, 2015 01:26:25 PM Jiang Liu wrote:
> On 2015/1/21 8:35, Rafael J. Wysocki wrote:
> > On Thursday, January 08, 2015 10:32:55 AM Jiang Liu wrote:
> >> From: Thomas Gleixner <tglx@linutronix.de>
> >>
> >> Add support of PREFETCH attributre to ACPI address space and extended
> >> address space parser.
> > 
> > This potentially enables untested configurations which tends to uncover bugs,
> > so I'm concerned.
> > 
> > What's the possible impact of this?
> Hi Rafael,
> 	I have analyzed all call sites related to this change, most
> users just care about resource type(IO, MEM, IRQ etc) and ignore
> the prefetch property. Seems only PCI subsystem cares about PREFETCH.

OK


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
