Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaFPR3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:29:39 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbaFPR3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:29:38 -0400
Message-ID: <539F297F.7010904@nod.at>
Date: Mon, 16 Jun 2014 19:29:35 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Richard Weinberger <richard.weinberger@gmail.com>
CC: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com> <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com>
In-Reply-To: <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.06.2014 19:25, schrieb Andy Lutomirski:
> On Mon, Jun 16, 2014 at 10:21 AM, Richard Weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Mon, Jun 16, 2014 at 6:33 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>>> $ cat syscall.c
>>> #include <unistd.h>
>>> #include <sys/syscall.h>
>>> int main(){return syscall(1000)!=-1;}
> 
> What architecture are you building for?  On i386 and x86_64, 1000
> shouldn't be big enough to trigger this.

Toralf, is this an UML kernel?

Thanks,
//richard
