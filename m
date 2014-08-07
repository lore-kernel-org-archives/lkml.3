Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbaHGQIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:08:35 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:65061 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaHGQId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:08:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140807133148.GC10043@pd.tnic>
References: <1407209178-18644-1-git-send-email-jiang.liu@linux.intel.com>
	<1407209178-18644-2-git-send-email-jiang.liu@linux.intel.com>
	<20140805183729.GA23068@pd.tnic>
	<53E201FC.6010102@linux.intel.com>
	<20140806170937.GA4895@pd.tnic>
	<20140807110332.GB10043@pd.tnic>
	<20140807113346.GA24225@gmail.com>
	<20140807133148.GC10043@pd.tnic>
Date: Thu, 7 Aug 2014 06:08:31 -1000
X-Google-Sender-Auth: q70KDSZJpy30QhiB7CQuArVQY7c
Message-ID: <CA+55aFzWZSc4vK5qK9jrjE1hfRSxdcWxmPHe7mfYWQtjY7WiSQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/apic changes for v3.17
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 3:31 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> This tree still needs the suspend/resume fixes on this thread AFAICT.
> Like keeping IRQ numbers of PCI devices stable across a s/r cycle, for
> example.
>
> I'm guessing you'll send Linus a follow-up pull request with those
> later, right?

If there are known issues with suspend/resume, I'm not willing to pull
this yet. The code for the merge window is supposed to be complete and
ready.

Ingo?

            Linus
