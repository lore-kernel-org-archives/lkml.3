Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbaHQVqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 17:46:47 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:53965 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaHQVqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 17:46:45 -0400
MIME-Version: 1.0
In-Reply-To: <53F11FF6.8030303@gmail.com>
References: <20140626151424.GT32514@n2100.arm.linux.org.uk>
	<20140627112151.GF32514@n2100.arm.linux.org.uk>
	<3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
	<20140627163108.GP32514@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>
	<20140806095012.GN30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int>
	<20140806125550.GO30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int>
	<20140807121248.GY30282@n2100.arm.linux.org.uk>
	<20140808180900.GG30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int>
	<CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com>
	<C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int>
	<CAOMZO5B7FgzB7ThVyV2Vk7wTwYgjRWjEnkkAN5uwwKMaBKq1yg@mail.gmail.com>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043577770@ALVA-EXMB04.alv.autoliv.int>
	<53F11FF6.8030303@gmail.com>
Date: Sun, 17 Aug 2014 18:46:42 -0300
Message-ID: <CAOMZO5CDvQDD7gVLFStwv4MPrUyqZE3sEDZwb0gukkXujYG-6Q@mail.gmail.com>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
From: Fabio Estevam <festevam@gmail.com>
To: Iain Paton <ipaton0@gmail.com>
Cc: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iain,

On Sun, Aug 17, 2014 at 6:34 PM, Iain Paton <ipaton0@gmail.com> wrote:
> On 15/08/14 06:42, Mattis Lorentzon wrote:
>
>> We mostly run SSH with benchmarks using NFS, it can probably be
>> triggered by using only SSH with the following loop:
>>
>> # while : ; do ssh arm-card date; done
>
> Mattis,
>
> What sort of time does it take for you to see a problem?
>
> I've been running the above for nearly two days on 3.16.0 on a board
> with fec interrupts routed through gpio_6 and haven't seen a hint of
> a problem.

Thanks for testing.

Which mx6 board have you used on this test?
