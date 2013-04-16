Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935498Ab3DPC4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 22:56:23 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:64741 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935212Ab3DPC4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 22:56:22 -0400
MIME-Version: 1.0
In-Reply-To: <516CB937.2000305@zytor.com>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
	<1365797627-20874-7-git-send-email-keescook@chromium.org>
	<CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com>
	<516A1D49.1050100@zytor.com>
	<CAG7+5M12cAavi9XBYoe39X=JtpWUu4wxjaAfOZP+=1qaKz7C+A@mail.gmail.com>
	<516C702C.2030209@zytor.com>
	<CAGXu5jJkA0y+5-or4vxUHE5GyNODSoefrYJO7scM1Jh56FoUuA@mail.gmail.com>
	<516C751B.4020505@zytor.com>
	<CAE9FiQW5X80bxOURTkhnELuV_AzYXBHEudxN1eUg_1jehrcfww@mail.gmail.com>
	<516CB937.2000305@zytor.com>
Date: Mon, 15 Apr 2013 19:56:21 -0700
X-Google-Sender-Auth: 9hKztu9vpIBCK15VeaVYExzSke4
Message-ID: <CAE9FiQU97FHKpKQjZJq+Nfz18eM2n0-V2n4B6m=ozjkycP+Rng@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, Eric Northup <digitaleric@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 7:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/15/2013 03:00 PM, Yinghai Lu wrote:
>>
>> looks you are trying redo the work for bootloader to pick loaded phys addr.
>>
>
> Well, that is exactly what they are doing.  On top of that they also
> need to randomize the 64-bit virtual mapping.
>
> I wonder if we need a bootloader bit to inhibit kaslr in addition to the
> command line...

so let the bootloader to parse kaslr and pick ramdom address,
and kernel arch/x86/boot/compressed/head_64.S to pick random virtual address?

Yinghai
