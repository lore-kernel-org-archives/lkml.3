Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3CHT6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:58:10 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:56154 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3CHT6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:58:08 -0500
MIME-Version: 1.0
In-Reply-To: <20130308194627.GB6622@phenom.dumpdata.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
	<1360351703-20571-6-git-send-email-yinghai@kernel.org>
	<20130308194627.GB6622@phenom.dumpdata.com>
Date: Fri, 8 Mar 2013 11:58:07 -0800
X-Google-Sender-Auth: x-s4q3YETYd2_1xwmK3b4gTDs-Q
Message-ID: <CAE9FiQUdTjSRZrsQ9AofFQszoe+0Moh+aKZHUQxiPJ-NM9S+OA@mail.gmail.com>
Subject: Re: [PATCH v2 05/26] x86, irq: Show pci device name for msi in /proc/interrupt
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 11:46 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Fri, Feb 08, 2013 at 11:28:02AM -0800, Yinghai Lu wrote:
>> We could find out which device is using that MSI/MSI-X.
>> Use irq_print_chip() to append pci device name.
>
> What would the end result be? For example for:
>
> 80:     some values PCI-MSI-edge      xhci_hcd
>
> Is it going to be:
>
> 80:     some values PCI-MSI-edge-xhci_hcd       xhci_hcd
>
> ?

should be PCI-MSI-edge@0000:01:00.0  xhci_hcd
