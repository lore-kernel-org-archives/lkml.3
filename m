Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbaFPRcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:32:36 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:43082 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPRcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:32:33 -0400
MIME-Version: 1.0
In-Reply-To: <539F297F.7010904@nod.at>
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com>
 <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com> <539F297F.7010904@nod.at>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 16 Jun 2014 10:32:12 -0700
Message-ID: <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
To: Richard Weinberger <richard@nod.at>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 10:29 AM, Richard Weinberger <richard@nod.at> wrote:
> Am 16.06.2014 19:25, schrieb Andy Lutomirski:
>> On Mon, Jun 16, 2014 at 10:21 AM, Richard Weinberger
>> <richard.weinberger@gmail.com> wrote:
>>> On Mon, Jun 16, 2014 at 6:33 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>>>> $ cat syscall.c
>>>> #include <unistd.h>
>>>> #include <sys/syscall.h>
>>>> int main(){return syscall(1000)!=-1;}
>>
>> What architecture are you building for?  On i386 and x86_64, 1000
>> shouldn't be big enough to trigger this.
>
> Toralf, is this an UML kernel?
>

I'm also interested in the userspace architecture.  If it's x32
userspace, then I'm not surprised that there's a problem.

--Andy

> Thanks,
> //richard



-- 
Andy Lutomirski
AMA Capital Management, LLC
