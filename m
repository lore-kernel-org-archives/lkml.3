Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723AbaE3Ply (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:41:54 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:52332 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500AbaE3PlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:41:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140530154229.46d76630@canb.auug.org.au>
References: <CALCETrXef77JLoEp5hCXSdMAk7usWsL-sUG6NrcgLgrz3krfag@mail.gmail.com>
 <cover.1401400316.git.luto@amacapital.net> <5387B7A0.3030302@windriver.com>
 <CALCETrVSG7-=Q3sG87YTzDYOLXzEbkvW9Ws=HeJ5cAUGxQhdJA@mail.gmail.com> <20140530154229.46d76630@canb.auug.org.au>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 30 May 2014 08:40:57 -0700
Message-ID: <CALCETrVooEK9beWde6b5rRO3OV995J+VHEQaJ=xzxTmJLT+ciA@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86,vdso: vdso build fixes and improvements
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:42 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andy,
>
> On Thu, 29 May 2014 15:49:52 -0700 Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> On Thu, May 29, 2014 at 3:41 PM, Paul Gortmaker
>> <paul.gortmaker@windriver.com> wrote:
>> > On 14-05-29 05:57 PM, Andy Lutomirski wrote:
>> >> Patch 1 causes make;make to behave similarly to make if vdso2c fails.
>> >> Patch 2 hopefully fixes x86 crossbuilds on big-endian machines.  I don't
>> >> have a big-endian machine to test on, though.
>> >
>> > Since the x86 builds are unconditionally failing as-is now in
>> > linux-next, perhaps Stephen [Cc'd] can layer these on the top of
>> > the tree he'll be making within the next couple of hours to give
>> > them a big-endian test.
>
> I added them just after the merge of the tip tree today and will keep
> them there until they (or somo other solution) turn up some other way.
>
>> Stephen, if you do this, could you also send me some of the build outputs:
>>
>> arch/x86/vdso/*.so.dbg
>> arch/x86/vdso/*-image-*.c
>>
>> I'd like to verify that the output is correct.  It would be
>> unfortunate if the cross-built kernel had some subtle error.
>
> OK, I will send them in a separate email.

For the benefit of the archives: the patches are bad.  New ones coming.

--Andy

>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
Andy Lutomirski
AMA Capital Management, LLC
