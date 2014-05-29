Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909AbaE2Tnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:43:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32790 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182AbaE2Tng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:43:36 -0400
Message-ID: <53878DCF.2050501@zytor.com>
Date: Thu, 29 May 2014 12:43:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-tip-commits@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [tip:x86/vdso] x86, vdso: Reimplement vdso.so preparation in
 build-time C
References: <2c4fcf45524162a34d87fdda1eb046b2a5cecee7.1399317206.git.luto@amacapital.net> <tip-6f121e548f83674ab4920a4e60afb58d4f61b829@git.kernel.org> <CAP=VYLrzMP23B9NVnu4N3NYsoU+ai1K9HpAE_eXQzXESUUZ-Lg@mail.gmail.com> <CALCETrWuHGnekoYZKJ6DAGtE8fQRMiPz590VQGctunvgee+uuA@mail.gmail.com>
In-Reply-To: <CALCETrWuHGnekoYZKJ6DAGtE8fQRMiPz590VQGctunvgee+uuA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 12:32 PM, Andy Lutomirski wrote:
> On Thu, May 29, 2014 at 12:17 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> On Mon, May 5, 2014 at 6:25 PM, tip-bot for Andy Lutomirski
>> <tipbot@zytor.com> wrote:
>>> Commit-ID:  6f121e548f83674ab4920a4e60afb58d4f61b829
>>> Gitweb:     http://git.kernel.org/tip/6f121e548f83674ab4920a4e60afb58d4f61b829
>>> Author:     Andy Lutomirski <luto@amacapital.net>
>>> AuthorDate: Mon, 5 May 2014 12:19:34 -0700
>>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>>> CommitDate: Mon, 5 May 2014 13:18:51 -0700
>>>
>>> x86, vdso: Reimplement vdso.so preparation in build-time C
>>
>> Just a heads up in case it hasn't been mentioned already;
>> the x86 builds in linux-next which IIRC are done as cross
>> compile on a powerpc box are failing as follows:
>>
>>   VDSO2C  arch/x86/vdso/vdso-image-64.c
>> /bin/sh: line 1: 15995 Segmentation fault      arch/x86/vdso/vdso2c
>> arch/x86/vdso/vdso64.so.dbg arch/x86/vdso/vdso-image-64.c
>> make[3]: *** [arch/x86/vdso/vdso-image-64.c] Error 139
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/11265454/
>>
> 
> Egads.  This wouldn't be a big-endian host by any chance?
> 

He said PowerPC; most but not all PowerPC systems are bigendian.  Seems
like a fair assumption to make.

	-hpa


