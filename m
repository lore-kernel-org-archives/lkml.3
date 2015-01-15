Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbbAOUAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 15:00:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53844 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbbAOUAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 15:00:49 -0500
Message-ID: <54B81C2E.2090909@zytor.com>
Date: Thu, 15 Jan 2015 11:59:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: EFI mixed mode + perf = rampant triple faults
References: <5491B4A8.905@amacapital.net> <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com> <20141231183739.GA28946@console-pimps.org> <20150114165151.GA3479@codeblueprint.co.uk> <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com> <20150115194127.GB12079@codeblueprint.co.uk>
In-Reply-To: <20150115194127.GB12079@codeblueprint.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 11:41 AM, Matt Fleming wrote:
>>
>> Tianocore makes assumptions about the kernel's GDT layout?  Yuck.
>
> No, but 32-bit Tianocore does rely on the second GDT entry being a
> 32-bit CS.
>
> It has no knowledge of Linux's GDT layout.
>

If it assumes that descriptor 16 is a 32-bit CS (and what about data? 
24?) that *is* making assumptions on the kernel.

	-hpa

