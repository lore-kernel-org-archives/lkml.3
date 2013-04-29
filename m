Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab3D2RnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:43:17 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:37176 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308Ab3D2RnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:43:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1304291124520.5728@tundra.namei.org>
References: <1367003005-5560-1-git-send-email-keescook@chromium.org>
	<1367003005-5560-4-git-send-email-keescook@chromium.org>
	<517AF5F2.50404@zytor.com>
	<alpine.LRH.2.02.1304291124520.5728@tundra.namei.org>
Date: Mon, 29 Apr 2013 10:43:13 -0700
X-Google-Sender-Auth: fSa6YPT1DthgieRlW8OsxOZSjCY
Message-ID: <CAGXu5jJwu0rCLJo4Qd4Vook11+_yZ=L0YJvHxf8Cx7gyo3yHYg@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH 3/6] x86: kaslr: return location
 from decompress_kernel
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
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

On Sun, Apr 28, 2013 at 6:25 PM, James Morris <jmorris@namei.org> wrote:
> On Fri, 26 Apr 2013, H. Peter Anvin wrote:
>
>> > +   noaslr          [X86]
>> > +                   Disable kernel base offset ASLR (Address Space
>> > +                   Layout Randomization) if built into the kernel.
>> > +
>> >     noautogroup     Disable scheduler automatic task group creation.
>> >
>> >     nobats          [PPC] Do not use BATs for mapping kernel lowmem
>>
>> Calling it "nokaslr" might be useful to note that it is specifically
>> about the kernel.
>
> Agreed.

Yeah, good call. I'll get this changed. Thanks!

-Kees

--
Kees Cook
Chrome OS Security
