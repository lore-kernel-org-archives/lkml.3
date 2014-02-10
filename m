Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaBJQbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:31:53 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57127 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaBJQbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:31:48 -0500
Message-ID: <20140210103148.187113o1jxn9inz4@67.228.131.205>
Date: Mon, 10 Feb 2014 10:31:48 -0600
From: linux@roeck-us.net
To: Michal Simek <monstr@monstr.eu>
Cc: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
        qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] Commit 34b9c07a3 (microblaze: Disable stack
 protection from bootloader) causing qemu crash
References: <20140207231731.GA8647@roeck-us.net>
 <20140208023131.GE24420@amz.ap-southeast-2.compute.internal>
 <CAHTX3dKz01P3P8y-8OC8WSMt68pPd2Y625bG97Y7B9s_VAGKDQ@mail.gmail.com>
In-Reply-To: <CAHTX3dKz01P3P8y-8OC8WSMt68pPd2Y625bG97Y7B9s_VAGKDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michal Simek <monstr@monstr.eu>:

> Hi Edgar and Guenter,
>
>
> 2014-02-08 Edgar E. Iglesias <edgar.iglesias@gmail.com>:
>
>> On Fri, Feb 07, 2014 at 03:17:31PM -0800, Guenter Roeck wrote:
>> > Michal,
>> >
>> > commit 34b9c07a3 (microblaze: Disable stack protection from bootloader)
>> results
>> > in the following qemu crash in 3.14-rc1.
>> >
>> > /opt/buildbot/bin/qemu-system-microblaze -M petalogix-s3adsp1800 -kernel
>> arch/microblaze/boot/linux.bin -no-reboot -append "console=ttyUL0,115200 "
>> -nographic
>> > qemu: fatal: fetching nop sequence
>> >
>> > IN: PC=20
>> > rmsr=4300 resr=7 rear=c0389fe8 debug=0 imm=ffffffd0 iflags=0 fsr=0
>> > btaken=1 btarget=c03a9f24 mode=kernel(saved=kernel) eip=512 ie=0
>> > r00=00000000 r01=c0389fcc r02=c0386a52 r03=000000c0
>> > r04=00004100 r05=9052fab4 r06=00000000 r07=90530ab4
>> > r08=00000000 r09=00400000 r10=00400000 r11=c03a9f24
>> > r12=00621000 r13=40aef0c0 r14=00000000 r15=c0000294
>> > r16=00000000 r17=c03a9f28 r18=00000000 r19=00000000
>> > r20=00000000 r21=00000000 r22=00000000 r23=00000000
>> > r24=00000000 r25=00000000 r26=00000000 r27=00000000
>> > r28=00000000 r29=00400000 r30=00000300 r31=c03932d4
>> >
>>
>
> Can you please check that these 2 registers are not available when
> microblaze is configured with full MMU?
> Because I expect that you are testing MMU kernel but these two writes
> should be just nops.
>

Hi Michal,

I can send you my configuration if that is what you are
looking for. Other than that, I am pretty clueless when
it comes to Microblaze details - all I do is to build
an image and check if it boots with qemu. This is part of
my sanity tests of upcoming -stable kernel versions.

It will have to wait until tonight, though - my home internet
connection is down and I can not connect to the system right
now.

Guenter

