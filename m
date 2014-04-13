Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaDMB3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 21:29:33 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:56350 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaDMB3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 21:29:31 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVwTTO43xQb8EiGdN-s8a04qU92p-t-Luo5z6aYVAvZig@mail.gmail.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
 <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu> <53485D95.9030301@zytor.com>
 <1397345179.1772.105823721.224E1140@webmail.messagingengine.com>
 <5349CCE3.3000003@zytor.com> <1397346568.13490.105824481.72FA2B8D@webmail.messagingengine.com>
 <5349D44C.9070105@zytor.com> <CALCETrVwTTO43xQb8EiGdN-s8a04qU92p-t-Luo5z6aYVAvZig@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 12 Apr 2014 18:29:11 -0700
Message-ID: <CALCETrU1DTc1Qo7ua5Pa0P8-XE8VoKLNoY17M6rGmJB2GP5KBw@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@jasper.es
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 6:25 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Sat, Apr 12, 2014 at 5:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> A signal arriving while in the user space trampoline could seriously
>> complicate life.
>
> Agreed.

Maybe I don't agree.  Have signals ever worked sensibly when delivered
to a task running on an unexpected stack or code segment?

--Andy
