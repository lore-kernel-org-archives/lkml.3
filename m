Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbaFPRgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:36:55 -0400
Received: from mout.gmx.net ([212.227.15.19]:63854 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaFPRgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:36:54 -0400
Message-ID: <539F2B2D.6050105@gmx.de>
Date: Mon, 16 Jun 2014 19:36:45 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Richard Weinberger <richard@nod.at>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com> <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com> <539F297F.7010904@nod.at> <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com>
In-Reply-To: <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:eleAafF+Ackk4I6+wUMnpPYW/ZFnw9vDRUHrJDez5uow6dirOSJ
 R63W5lYhczAyhXefhurA8toriV+eMAJVFFI/AClSKSNn5cY78d6DleQ3v7K9P28bei5sC0+
 aWEmr7S+uNZzm9MJ8SQV7my4wKG/npqXVc2uw9wzztdTdwEyszsCS1/uRQLsmC43l8yr/mW
 JW9W69OrgrQJ70DwsWxBg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 07:32 PM, Andy Lutomirski wrote:
> On Mon, Jun 16, 2014 at 10:29 AM, Richard Weinberger <richard@nod.at> wrote:
>> Am 16.06.2014 19:25, schrieb Andy Lutomirski:
>>> On Mon, Jun 16, 2014 at 10:21 AM, Richard Weinberger
>>> <richard.weinberger@gmail.com> wrote:
>>>> On Mon, Jun 16, 2014 at 6:33 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>>>>> $ cat syscall.c
>>>>> #include <unistd.h>
>>>>> #include <sys/syscall.h>
>>>>> int main(){return syscall(1000)!=-1;}
>>>
>>> What architecture are you building for?  On i386 and x86_64, 1000
>>> shouldn't be big enough to trigger this.
>>
>> Toralf, is this an UML kernel?
>>
> 
> I'm also interested in the userspace architecture.  If it's x32
> userspace, then I'm not surprised that there's a problem.

It is a x86 system (ThinkPad T420) - not x32.


-- 
Toralf

