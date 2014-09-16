Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaIPOe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 10:34:59 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62491 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbaIPOe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 10:34:57 -0400
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] arch/microblaze/kernel/setup.c: Add default 'screen_info" for fixing compiling break
From: Chen Gang <gang.chen.5i5j@gmail.com>
X-Mailer: iPad Mail (11D257)
In-Reply-To: <54181810.1060105@monstr.eu>
Date: Tue, 16 Sep 2014 22:34:52 +0800
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <rob.herring@calxeda.com>, Paul Bolle <pebolle@tiscali.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6C301F81-7F63-4DB5-88EE-F5D481E04B83@gmail.com>
References: <541552B8.8020807@gmail.com> <CAMuHMdU6adYoOafUZ2STZCeuQa3cU-_kD7FHW3x=Tq-O+aqrZw@mail.gmail.com> <541559C2.8070703@gmail.com> <5418019E.1010202@monstr.eu> <CAMuHMdWnZVi9rXzmOxsuwMeUcCvW_CH0bi_KuYiCNcp3JQHhLA@mail.gmail.com> <54181810.1060105@monstr.eu>
To: "monstr@monstr.eu" <monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank all of your work. And I also try some patches for microblaze compiler,
hope I  can finish within this month (already got much help from related gcc
maintainer). And next month, I shall start Qemu for microblaze.

Thanks again.

发自我的 iPad

在 2014年9月16日，下午6:59，Michal Simek <monstr@monstr.eu> 写道：

>>>> Welcome the related microblaze maintainers ideas for it
>>> 
>>> Is this is just about VGA or video console in general?
>>> There is xilinx FB driver and other FB are around too.
>> 
>> These days screen_info is only used by:
>>  - vgacon,
>>  - dummycon on ARM,
>>  - a few fb drivers (efifb, intelfbdrv,sis, vesafb, and vga16fb).
>> 
>> E.g. m68k doesn't have it.
> 
> ok. IRC I think I remember one non mainline FB driver which required it too.
> It breaks nothing for me that's why no problem to apply it.
