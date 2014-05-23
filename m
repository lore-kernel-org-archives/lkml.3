Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaEWQuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:50:11 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:57509 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaEWQuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:50:09 -0400
MIME-Version: 1.0
In-Reply-To: <CA+r1ZhjZoDK-rxZ8EGDk==b7EXNDsdxo8EAt2WFhdHt4-W0k=g@mail.gmail.com>
References: <CA+r1ZhjZoDK-rxZ8EGDk==b7EXNDsdxo8EAt2WFhdHt4-W0k=g@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 23 May 2014 10:49:47 -0600
Message-ID: <CAErSpo6vJAEd2-qSCWt_j5L2sFDeh1iK3=G+_5pz32WdsNfhKA@mail.gmail.com>
Subject: Re: randconfig build error with next-20140523, in arch/x86/pci/fixup.c
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>,
        hpa <hpa@zytor.com>, x86 <x86@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 10:13 AM, Jim Davis <jim.epost@gmail.com> wrote:
> Building with the attached random configuration file,
>
> arch/x86/pci/fixup.c: In function ‘sb600_hpet_quirk’:
> arch/x86/pci/fixup.c:534:47: error: ‘hpet_address’ undeclared (first use in this
>  function)
>   if (r->flags & IORESOURCE_MEM && r->start == hpet_address) {
>                                                ^
> arch/x86/pci/fixup.c:534:47: note: each undeclared identifier is reported only o
> nce for each function it appears in
> make[1]: *** [arch/x86/pci/fixup.o] Error 1

Thanks, I updated that patch to test CONFIG_HPET_TIMER.

Bjorn
