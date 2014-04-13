Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaDMDBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 23:01:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59290 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbaDMDBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 23:01:16 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrU1DTc1Qo7ua5Pa0P8-XE8VoKLNoY17M6rGmJB2GP5KBw@mail.gmail.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu> <53485D95.9030301@zytor.com> <1397345179.1772.105823721.224E1140@webmail.messagingengine.com> <5349CCE3.3000003@zytor.com> <1397346568.13490.105824481.72FA2B8D@webmail.messagingengine.com> <5349D44C.9070105@zytor.com> <CALCETrVwTTO43xQb8EiGdN-s8a04qU92p-t-Luo5z6aYVAvZig@mail.gmail.com> <CALCETrU1DTc1Qo7ua5Pa0P8-XE8VoKLNoY17M6rGmJB2GP5KBw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 12 Apr 2014 20:00:46 -0700
To: Andy Lutomirski <luto@amacapital.net>
CC: Alexander van Heukelum <heukelum@fastmail.fm>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@jasper.es
Message-ID: <767784e4-73ca-4631-9fbe-16db3e94bbe5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would think any sensible application with 16-bit segments would be using sigaltstack.  Does anyone know what Wine does?

On April 12, 2014 6:29:11 PM PDT, Andy Lutomirski <luto@amacapital.net> wrote:
>On Sat, Apr 12, 2014 at 6:25 PM, Andy Lutomirski <luto@amacapital.net>
>wrote:
>> On Sat, Apr 12, 2014 at 5:03 PM, H. Peter Anvin <hpa@zytor.com>
>wrote:
>>> A signal arriving while in the user space trampoline could seriously
>>> complicate life.
>>
>> Agreed.
>
>Maybe I don't agree.  Have signals ever worked sensibly when delivered
>to a task running on an unexpected stack or code segment?
>
>--Andy

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
