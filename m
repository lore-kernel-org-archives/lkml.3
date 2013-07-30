Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3G3MSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:18:49 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51703 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3G3MSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:18:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130730065253.GE7656@atomide.com>
References: <51F67D7D.9070003@ti.com>
	<1375117383-19285-1-git-send-email-nm@ti.com>
	<51F6EA23.50803@gmail.com>
	<20130730065253.GE7656@atomide.com>
Date: Tue, 30 Jul 2013 07:18:45 -0500
X-Google-Sender-Auth: tA6MMEZwF7mz2GDqC0sgw_-xfw4
Message-ID: <CAGo_u6qqGaMKGE66wt_EqeGGcdxNm2jmp6H+NCMeCuswLHT3rA@mail.gmail.com>
Subject: Re: [PATCH V2 0/3] ARM: dts: omap5-uevm: fixup wrong regulator configuration
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Benoit Cousson <benoit.cousson@gmail.com>,
        l-o <linux-omap@vger.kernel.org>, dt list <devicetree@vger.kernel.org>,
        l-a <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, J Keerthy <j-keerthy@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 1:52 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Benoit Cousson <benoit.cousson@gmail.com> [130729 15:24]:
>> On 29/07/2013 19:03, Nishanth Menon wrote:
>> > Due to wrong older revision of documentation used as reference, we
>> > seem to have a bunch of LDOs wrongly configured on OMAP5 uEVM. This
>> > series is based power tree on production board 750-2628-XXX platform.
>> > Unfortunately, the wrong voltages may be detrimental to OMAP5 as they
>> > supply hardware blocks at voltages that are out of specification.
>> >
>> > Also available at:
>> > based on v3.11-rc1 tag
>> > http link: https://github.com/nmenon/linux-2.6-playground/commits/push/omap5-palmas-fixes-v2
>> > git link: git://github.com/nmenon/linux-2.6-playground.git
>> > branch: push/omap5-palmas-fixes-v2
>> >
>> > Changes since V1:
>> >  - squash of patches
>> >  - picked up Ack from Keerthy
>> >  - based on v3.11-rc3 tag
>> >
>> > V1: http://marc.info/?t=137407980100008&r=1&w=2
>> >
>> > Nishanth Menon (3):
>> >   ARM: dts: omap5-uevm: document regulator signals used on the actual
>> >     board
>> >   ARM: dts: omap5-uevm: fix regulator configurations mandatory for SoC
>> >   ARM: dts: omap5-uevm: update optional/unused regulator configurations
>> >
>> >  arch/arm/boot/dts/omap5-uevm.dts |   78 ++++++++++++++++++++++++--------------
>> >  1 file changed, 49 insertions(+), 29 deletions(-)
>> >
>> > Regards,
>> > Nishanth Menon
>>
>> For the whole series:
>>
>> Acked-by: Benoit Cousson <benoit.cousson@gmail.com>
>
> Thanks, I've applied these into omap-for-v3.11/fixes-omap5
> and will send a pull request for these today as these seem
> quite urgent fixes.
yes they are. thanks for picking these up and the reviews.

Regards,
Nishanth Menon
