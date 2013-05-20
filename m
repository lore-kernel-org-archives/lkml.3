Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab3ETQgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:36:53 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:62943 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab3ETQgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:36:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75Vdf6gFZChS47=grUygHBDWcoOWDYPzw+Zj5bdVCWj85Jw@mail.gmail.com>
References: <CAHp75Vdf6gFZChS47=grUygHBDWcoOWDYPzw+Zj5bdVCWj85Jw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 20 May 2013 10:36:30 -0600
Message-ID: <CAErSpo64ASrw=Kryi946cPjmyUWOjeaRf24xD69gbjYVzKanbg@mail.gmail.com>
Subject: Re: The dd72be99 breaks some of Intel Medfield based devices
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Bin Gao <bin.gao@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci and cc list of Bin's original posting]

On Mon, May 20, 2013 at 9:09 AM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> Hi!
>
> I don't know what you trying to fix, but your patch dd72be99
> "x86/pci/mrst: Use configuration mechanism 1 for 00:00.0, 00:02.0,
> 00:03.0" breaks Intel Medfield devices.
>
> After it was applied (sorry, was on vacation, didn't noticed sooner)
> lspci shows only 18 out of 34 devices. That means the so called fake
> PCI devices are gone.
>
> This is a bad approach and patch should be reverted. Bin, please,
> explain what you are trying to fix and on what device. We will find
> better solution.

I reverted dd72be99 in my for-linus branch.  I guess I should have let
that sit in -next for a cycle before asking Linus to pull it.  Sorry
about jumping the gun.

I'll wait for a patch tested by both Bin and Andy.

Bjorn
