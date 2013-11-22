Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab3KVB3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:29:06 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:39849 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3KVB3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:29:02 -0500
MIME-Version: 1.0
In-Reply-To: <20131122012524.GA5627@anatevka.fc.hp.com>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
	<20131121230744.GA31592@srcf.ucam.org>
	<528E94D1.2050809@zytor.com>
	<20131121233705.GA32121@srcf.ucam.org>
	<528EAF99.1010503@zytor.com>
	<20131122012524.GA5627@anatevka.fc.hp.com>
Date: Thu, 21 Nov 2013 17:29:01 -0800
X-Google-Sender-Auth: FuOy2y2IJaqx9HQiusRyBL6txfg
Message-ID: <CAE9FiQUx5rnA0kpqXRQYtpj9Qk-4bPGaUKEbbF=XHsZbnSd6Rg@mail.gmail.com>
Subject: Re: [RFC v2 0/2] Early use of boot service memory
From: Yinghai Lu <yinghai@kernel.org>
To: jerry.hoemann@hp.com, Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 5:25 PM,  <jerry.hoemann@hp.com> wrote:
> On Thu, Nov 21, 2013 at 05:12:57PM -0800, H. Peter Anvin wrote:
>
> Large systems w/ lots of IO require large crash kernel allocations for
> the kernel to boot.  Then you have to worry about the OOM killer.....

so go with crashkernel=1024M,high.

>
> makedumpfile going to cyclic buffer has helped out greatly, but on
> our new systems we're still looking at 512 MB crash kernels.

I tried 6TiB system/16 PCIE cards, kdump on RHEL 6.5 beta still does not work.
still get OOM.

Thanks

Yinghai
