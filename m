Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab3DZVv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 17:51:56 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:60502 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3DZVvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 17:51:54 -0400
MIME-Version: 1.0
In-Reply-To: <1367003005-5560-6-git-send-email-keescook@chromium.org>
References: <1367003005-5560-1-git-send-email-keescook@chromium.org>
	<1367003005-5560-6-git-send-email-keescook@chromium.org>
Date: Fri, 26 Apr 2013 14:51:54 -0700
X-Google-Sender-Auth: Ds2HQdwEVmNcoZkU4L1pRwGnc10
Message-ID: <CAE9FiQVA17TGuY5_DFGUL8OSMLx+yJQV1fhe7JDkaoq1a9-oSw@mail.gmail.com>
Subject: Re: [PATCH 5/6] x86: kaslr: select memory region from e820 maps
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
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

On Fri, Apr 26, 2013 at 12:03 PM, Kees Cook <keescook@chromium.org> wrote:
> This chooses the largest contiguous RAM region for the KASLR offset
> to live in.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
>  - make sure to exclude e820 regions outside the 32-bit memory range.

Do you need to execlude range that is used for initrd and possible
command_line and boot_param ?

Yinghai
