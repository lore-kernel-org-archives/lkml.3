Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923Ab3GPTmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:42:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58385 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202Ab3GPTm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:42:28 -0400
Message-ID: <51E5A207.30204@zytor.com>
Date: Tue, 16 Jul 2013 12:41:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 1/3] x86, boot: add mmio serial during compressed boot
References: <1373659660-31123-1-git-send-email-keescook@chromium.org> <20130712203802.GA14702@www.outflux.net> <CAE9FiQWJin8-hXsodo46vhYPMrWiiboEVQySPO-LgXtebYmUzw@mail.gmail.com> <CAGXu5jJs5ve-31AYKbv6EaV5PKCf5cOEeWTRsYsi_kBbLWj5uQ@mail.gmail.com> <51E5A0A9.90108@zytor.com> <CAGXu5jJJXgnJxuvc851UZ4Du10HSBJnDWc7rKgRb4_=ojMmtug@mail.gmail.com>
In-Reply-To: <CAGXu5jJJXgnJxuvc851UZ4Du10HSBJnDWc7rKgRb4_=ojMmtug@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 12:40 PM, Kees Cook wrote:
>>
>> I think setting up a dynamic #PF handler is the right thing for the
>> decompressor, we already did for the kernel proper.
> 
> I'm not sure how to accomplish this yet. I'm still trying to
> understand how the page tables are arranged. :)
> 

Look at the handler at the top of arch/x86/kernel/head64.c.

	-hpa


