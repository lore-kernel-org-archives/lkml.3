Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaGHJOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:14:36 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaGHJOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:14:34 -0400
Message-ID: <53BBB677.2010401@nod.at>
Date: Tue, 08 Jul 2014 11:14:31 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Konstantin Khlebnikov <koct9i@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [uml-devel] [PATCH] checkstack: use $UTS_MACHINE as target architecture
References: <20140705112238.16142.42735.stgit@zurg>	<20140707150523.cc671116bf366e8db73209c5@linux-foundation.org>	<CALYGNiMjL_GYqqkid4yQsubpnbydVXxTPnKW0GqJcg05x9zbHQ@mail.gmail.com>	<CAFLxGvzxvuizdHyjQ0SjUm8jJcj=w+qS5ut-u76Xo-m2sftvvw@mail.gmail.com>	<CALYGNiOTC8KOxWwRo+f=6JmtUYhJ=1cQNq-Us1BZbW85r4P+ug@mail.gmail.com>	<53BBA9B4.7050609@nod.at>	<CALYGNiNSFoW6Z_1o3JfV-cCeay1QmTptrt4kWHVegkuw+-6A8A@mail.gmail.com>	<53BBACF4.4070800@nod.at>	<CALYGNiND3xk4DGkM_RYApmX7BMkg=cKX2gUpyyOry0ny_DVrkA@mail.gmail.com>	<53BBB0F2.20109@nod.at>	<CALYGNiPakwGquDk9MVGeSrx4RmUOg21=_Zcw097Z5sGTsP=Cwg@mail.gmail.com>	<53BBB4AF.1080507@nod.at> <CAMuHMdXczkVGAejZ2RnsdXYvTq-8eZAhheR-ygXmXKMmh9VsEA@mail.gmail.com>
In-Reply-To: <CAMuHMdXczkVGAejZ2RnsdXYvTq-8eZAhheR-ygXmXKMmh9VsEA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.07.2014 11:09, schrieb Geert Uytterhoeven:
> On Tue, Jul 8, 2014 at 11:06 AM, Richard Weinberger <richard@nod.at> wrote:
>> Am 08.07.2014 11:03, schrieb Konstantin Khlebnikov:
>>> I know. But debugging/profiling of kernel code is much easier when it
>>> runs in userspace.
>>> I think this is the last use case where uml might beat normal hardware
>>> accelerated qemu/kvm.
>>> But without SMP and with that high overhead on each syscall and
>>> context/mm switch it's mostly useless.
>>
>> The major use case of UML is that you can run it on hardware without
>> KVM support.
>> Everyone else is using KVM.
> 
> And that you don't need root permissions to run it.
> Which is why I'm still interested in an ARM port.
> Need... More... Spare... Time...

You can use KVM also without being root.
It depends on the rights of /dev/kvm.

But yes, an ARM ports would be nice to have. :)

Thanks,
//richard
