Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3EBHGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:06:53 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39612 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3EBHGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:06:47 -0400
MIME-Version: 1.0
In-Reply-To: <6D83E89737156549AEA25EF9ED712C5DE3D0@DEFTHW99EK1MSX.ww902.siemens.net>
References: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
	<m2a9ohusmp.fsf@firstfloor.org>
	<6D83E89737156549AEA25EF9ED712C5DE0A9@DEFTHW99EK1MSX.ww902.siemens.net>
	<20863.43739.999287.287981@pilspetsen.it.uu.se>
	<6D83E89737156549AEA25EF9ED712C5DE208@DEFTHW99EK1MSX.ww902.siemens.net>
	<20863.55352.431848.272078@pilspetsen.it.uu.se>
	<6D83E89737156549AEA25EF9ED712C5DE3D0@DEFTHW99EK1MSX.ww902.siemens.net>
Date: Thu, 2 May 2013 09:06:46 +0200
Message-ID: <CAFLxGvyERB-00J9ZYUzphVd=C5wzBLnYWcP7U58sEmHLH5_-Jg@mail.gmail.com>
Subject: Re: X86 fpu registers in a signal handler's ucontext
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "Warlich, Christof" <christof.warlich@siemens.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 7:42 AM, Warlich, Christof
<christof.warlich@siemens.com> wrote:
> Mikael Pettersson <mikpe@it.uu.se> writes:
>> You're looking at the wrong header: glibc-2.17/sysdeps/i386/sys/ucontext.h is legacy SVR4.
>> Instead look at glibc-2.17/sysdeps/unix/sysv/linux/x86/sys/ucontext.h.
>>
>> (If the old one got installed on your system then something there is seriously wrong.)
>
> Oh-oh: It looks like my system was simply too old: Initially, I was looking at Ubuntu 11.10
> with an eglibc-2.13, and a double-check with a newly downloaded glibc-2.17 lead me to the
> wrong file.

Are you telling us that Ubuntu shipped the wrong header file?

--
Thanks,
//richard
