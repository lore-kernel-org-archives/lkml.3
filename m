Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162691Ab3DEUBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:01:07 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:65157 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162637Ab3DEUBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:01:06 -0400
MIME-Version: 1.0
In-Reply-To: <515DE0C9.3030709@zytor.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
	<1365106055-22939-4-git-send-email-keescook@chromium.org>
	<515DE0C9.3030709@zytor.com>
Date: Fri, 5 Apr 2013 13:01:04 -0700
X-Google-Sender-Auth: yd6P0mM77AgrXADT0R1O2ZalJyc
Message-ID: <CAE9FiQVCC2-yF0+bt2MryHDs2vK8bcsU1aE-is_ejDDF0dTbMQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 1:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I have to admit to being somewhat skeptical toward KASLR with only 8
> bits of randomness.  There are at least two potential ways of
> dramatically increasing the available randomness:
>
> 1. actually compose the kernel of multiple independently relocatable
>    pieces (maybe chunk it on 2M boundaries or something.)
>
> 2. compile the kernel as one of the memory models which can be executed
>    anywhere in the 64-bit address space.  The cost of this would have
>    to be quantified, of course.

Why just let bootloader to load kernel on random address instead?

For our 64bit bzImage, boot loader could load kernel to anywhere above 4G.

Thanks

Yinghai
