Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbaGURXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:23:49 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:61508 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaGURXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:23:46 -0400
MIME-Version: 1.0
In-Reply-To: <53CD4BE8.5030603@zytor.com>
References: <alpine.LNX.2.11.1407202330420.31021@titan.int.lan.stealer.net>
 <90404aa5-cab6-44aa-9eab-4106cb16e7ab@email.android.com> <CALCETrUijU1f+WJ5RkOa0X1y9K1UYWEQGdVwwGfBHdVS9iBciA@mail.gmail.com>
 <53CD4BE8.5030603@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 21 Jul 2014 10:23:25 -0700
Message-ID: <CALCETrV-fy6cA3fx40V3fnEN5bXMnDkYi845oKLYWXhVu=zRjw@mail.gmail.com>
Subject: Re: [PATCH] x86_32, entry: store badsys error code in %eax
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sven Wegener <sven.wegener@stealer.net>,
        Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>,
        Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        stable <stable@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:20 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/21/2014 09:53 AM, Andy Lutomirski wrote:
>> On Sun, Jul 20, 2014 at 3:07 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> This is not a subtle regression at all.  It is in fact a very very serious one.
>>
>> Indeed.
>>
>> Does this really work correctly on sysenter?  It sure looks like the
>> sysenter path has the same problem.
>>
>> Grr.  I'm not set up to properly test 32-bit kernels.  The patch looks
>> correct, but I'm obviously not an infallible authority on "looking
>> correct" when it comes to entry_32.S.
>>
>> --Andy
>>
>
> KVM is great for that sort of things.

This may finally inspire me to teach virtme how to boot an alternate
root.  I got sick of dealing with VM images awhile ago.

--Andy

>
>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
