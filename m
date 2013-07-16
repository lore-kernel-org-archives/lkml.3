Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933818Ab3GPWFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:05:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59706 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933597Ab3GPWFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:05:14 -0400
Message-ID: <51E5C38D.1090201@zytor.com>
Date: Tue, 16 Jul 2013 15:05:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 1/3] x86, boot: add mmio serial during compressed boot
References: <1373659660-31123-1-git-send-email-keescook@chromium.org> <20130712203802.GA14702@www.outflux.net> <CAE9FiQWJin8-hXsodo46vhYPMrWiiboEVQySPO-LgXtebYmUzw@mail.gmail.com> <CAGXu5jJs5ve-31AYKbv6EaV5PKCf5cOEeWTRsYsi_kBbLWj5uQ@mail.gmail.com> <51E5A0A9.90108@zytor.com> <CAGXu5jJJXgnJxuvc851UZ4Du10HSBJnDWc7rKgRb4_=ojMmtug@mail.gmail.com> <CAE9FiQUAGPgqU3vOOjKJva=nN71CKoOEdpyjg_23-OfgFSkG=A@mail.gmail.com>
In-Reply-To: <CAE9FiQUAGPgqU3vOOjKJva=nN71CKoOEdpyjg_23-OfgFSkG=A@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 02:03 PM, Yinghai Lu wrote:
> 
> Other way could be:
> 
> Detect if it get into misc.c directly from
> arch/x86/boot/compressed/head_64.S::startup_64. that is from 64bit
> bootloader.
> 
> others go through startup_32 should be 32bit bootloader.
> 
> If it with 64bit boot loader path, You can skip parsing mmio in
> misc.c::console_init() calling.
> 

Don't hack around it when we can do it right.

	-hpa


