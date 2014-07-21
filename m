Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbaGURYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:24:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44686 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbaGURYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:24:00 -0400
Message-ID: <53CD4BE8.5030603@zytor.com>
Date: Mon, 21 Jul 2014 10:20:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Sven Wegener <sven.wegener@stealer.net>,
        Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>,
        Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        stable <stable@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: [PATCH] x86_32, entry: store badsys error code in %eax
References: <alpine.LNX.2.11.1407202330420.31021@titan.int.lan.stealer.net> <90404aa5-cab6-44aa-9eab-4106cb16e7ab@email.android.com> <CALCETrUijU1f+WJ5RkOa0X1y9K1UYWEQGdVwwGfBHdVS9iBciA@mail.gmail.com>
In-Reply-To: <CALCETrUijU1f+WJ5RkOa0X1y9K1UYWEQGdVwwGfBHdVS9iBciA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 09:53 AM, Andy Lutomirski wrote:
> On Sun, Jul 20, 2014 at 3:07 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> This is not a subtle regression at all.  It is in fact a very very serious one.
> 
> Indeed.
> 
> Does this really work correctly on sysenter?  It sure looks like the
> sysenter path has the same problem.
> 
> Grr.  I'm not set up to properly test 32-bit kernels.  The patch looks
> correct, but I'm obviously not an infallible authority on "looking
> correct" when it comes to entry_32.S.
> 
> --Andy
> 

KVM is great for that sort of things.

	-hpa


